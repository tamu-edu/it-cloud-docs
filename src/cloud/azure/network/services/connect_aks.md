# Azure Kubernetes Service (AKS)

- **Rule:** AKS clusters may not expose the API server or workload ingress directly to the public internet, and must be deployed with VNet integration into the spoke VNet with outbound traffic routed through the hub firewall.
- **Action:** Deploy AKS as a **private cluster** with the API server reachable only via private networking, use a CNI mode that integrates pods with the spoke VNet, set the cluster's outbound type to `userDefinedRouting` so egress flows through the hub firewall, and expose workloads using an internal load balancer fronted by hub-managed AFD where public access is required.

## Summary

- The AKS API server must be private. Use either **API Server VNet Integration** (recommended) or a **private cluster** with a private endpoint. Public API server endpoints are not permitted.
- The cluster must use a CNI plugin that integrates with the VNet — **Azure CNI Overlay** (recommended for most workloads) or **Azure CNI with dynamic IP allocation / pod subnet**. `kubenet` is not recommended due to its UDR/route table limitations and deprecation trajectory. Azure CNI requires a large amount of IPs - coordinate with Cloud Services to have additional IPs allocated to your spoke VNet.
- The cluster must be configured with `outbound_type = "userDefinedRouting"` so all egress flows through the hub firewall via the spoke's UDR. The default `loadBalancer` outbound type provisions a public IP and is not permitted.
- A dedicated subnet must be provided for the cluster's nodes. If using Azure CNI with a pod subnet (dynamic IP allocation), an additional dedicated pod subnet must also be provided. Subnets must be sized for the maximum expected node and pod counts.
- NSGs on AKS subnets must permit the platform traffic AKS requires plus your application traffic from approved sources. Avoid blocking intra-cluster traffic between the node subnet and pod subnet.
- For internet-facing application traffic, expose workloads through an **internal** ingress controller or internal load balancer service (`service.beta.kubernetes.io/azure-load-balancer-internal: "true"`) and front it with the shared hub-managed Azure Front Door via Private Link.
- Container images must be pulled from a private Azure Container Registry with a Private Endpoint where possible. Public registry pulls will traverse the hub firewall and may be subject to filtering.
- Administrative access (`kubectl`, `az aks command invoke`) must use private networking. Use Azure Bastion to a jump host in the VNet, the campus VPN, or `az aks command invoke` (which tunnels through the Azure control plane) — see [Access Methods](../access_methods.md).
- The cluster identity must have appropriate RBAC on the spoke VNet, node subnet, pod subnet, and any private DNS zones used for the private API server. Use a user-assigned managed identity to keep these role assignments stable across cluster lifecycle operations.

## Implementation Pattern

### Networking Model

AKS networking is more involved than other PaaS services because the cluster manages both control plane connectivity and pod-to-pod / pod-to-external traffic. Three decisions drive the network design:

1. **API server exposure** — How clients reach the Kubernetes API.
2. **CNI mode** — How pods get IP addresses and how they communicate with the VNet.
3. **Outbound type** — How pods reach the internet and other Azure services.

For the TAMU managed network, the recommended combination is:

| Decision | Recommended | Notes |
|---|---|---|
| API server | API Server VNet Integration | Lower latency, simpler than legacy private clusters, no separate private endpoint to manage. Private cluster with private endpoint is also acceptable. |
| CNI mode | Azure CNI Overlay | Pods get IPs from a separate overlay CIDR not consumed from the VNet, which avoids large VNet subnet allocations. Choose Azure CNI with pod subnet if pods must be directly addressable from the VNet (e.g., for some service mesh or Private Link scenarios). |
| Outbound type | `userDefinedRouting` | Forces egress through the hub firewall via the spoke UDR. Required. |
| Load balancer SKU | Standard | Required by `userDefinedRouting`. Internal-only LBs are used for service exposure. |

Refer to the Microsoft documentation for the authoritative details:

- [Concepts – Networking in AKS](https://learn.microsoft.com/en-us/azure/aks/concepts-network)
- [API Server VNet Integration](https://learn.microsoft.com/en-us/azure/aks/api-server-vnet-integration)
- [Create a private AKS cluster](https://learn.microsoft.com/en-us/azure/aks/private-clusters)
- [Azure CNI Overlay networking](https://learn.microsoft.com/en-us/azure/aks/azure-cni-overlay)
- [Configure Azure CNI with dynamic IP allocation](https://learn.microsoft.com/en-us/azure/aks/configure-azure-cni-dynamic-ip-allocation)
- [Customize cluster egress with `userDefinedRouting`](https://learn.microsoft.com/en-us/azure/aks/egress-outboundtype)
- [Limit network traffic with Azure Firewall in AKS](https://learn.microsoft.com/en-us/azure/aks/limit-egress-traffic)

### Subnet Layout

At minimum, allocate the following subnets in your spoke VNet for AKS:

- **Node subnet** — Hosts the AKS node VMs. Size for the maximum node count plus headroom for upgrades (a `/24` is a reasonable starting point for small/medium clusters; size up for larger clusters).
- **Pod subnet** (only when using Azure CNI with dynamic IP allocation) — Hosts pod IPs allocated from the VNet. Must be significantly larger than the node subnet because each node pre-allocates a block of pod IPs.
- **API Server subnet** (only when using API Server VNet Integration) — A small dedicated subnet (typically `/28`) delegated to `Microsoft.ContainerService/managedClusters` for the integrated API server.
- **Internal ingress subnet** (optional) — A subnet that internal load balancer services / ingress controllers can use via the `service.beta.kubernetes.io/azure-load-balancer-ipv4` and subnet annotations, kept separate from the node subnet for cleaner NSG scoping.

All of these subnets must be associated with the spoke's UDR (routing `0.0.0.0/0` to the hub firewall) except where Microsoft documentation explicitly requires otherwise. The API server delegated subnet has its own routing requirements — follow the Microsoft documentation for that subnet specifically.

### Private API Server with VNet Integration

The recommended pattern is to use API Server VNet Integration so the API server is reachable on a private IP allocated from a dedicated subnet in your spoke VNet, without the legacy private cluster's separate private endpoint and private DNS zone management.

Key points for the TAMU managed network:

1. Create the API server delegated subnet in your spoke VNet (typically `/28`), delegated to `Microsoft.ContainerService/managedClusters`.
2. Create the cluster with `--enable-api-server-vnet-integration` and `--apiserver-subnet-id` referencing the delegated subnet.
3. Set `--outbound-type userDefinedRouting` and confirm the spoke UDR routes `0.0.0.0/0` to the hub firewall.
4. Use a user-assigned managed identity for the cluster and pre-assign the required roles on the VNet, node subnet, pod subnet (if applicable), and API server subnet before cluster creation. This avoids needing `Owner` on the VNet during cluster creation.

If your scenario requires the legacy **private cluster** model instead (for example, for tooling that assumes a private endpoint to the API server), follow the [private cluster documentation](https://learn.microsoft.com/en-us/azure/aks/private-clusters) and select `No` when prompted to integrate with a private DNS zone — DNS records will be created automatically in the appropriate private DNS zone in the hub VNet. Contact Cloud Services if records do not appear.

### CNI Mode Selection

- **Azure CNI Overlay** — Pods receive IPs from a cluster-internal overlay CIDR (e.g., `10.244.0.0/16`) that is not consumed from the VNet. Pod-to-VNet and pod-to-internet traffic is SNATed to the node IP. This is the recommended mode for most workloads because it avoids consuming large VNet address ranges and simplifies subnet sizing. Use this unless you have a specific requirement for pods to be directly VNet-addressable.
- **Azure CNI with dynamic IP allocation (pod subnet)** — Pods receive IPs from a dedicated pod subnet in the VNet, and each pod is directly addressable from the VNet. Required for some Private Link, service mesh, or workload identity scenarios that need pod-level VNet addressability. Plan for a much larger pod subnet than node subnet.
- **kubenet** — Not recommended. Limited UDR support, scaling limits, and on Microsoft's deprecation path.

### Outbound Traffic via the Hub Firewall

Setting `outbound_type = "userDefinedRouting"` forces AKS to rely on the spoke UDR for egress. Microsoft publishes a [list of required outbound FQDNs and network rules](https://learn.microsoft.com/en-us/azure/aks/outbound-rules-control-egress) that the hub firewall must permit for the cluster to function — including the AKS control plane, MCR, package mirrors, and Azure Monitor endpoints. Submit a Cloud Services request before cluster creation listing:

- The cluster's region.
- The Kubernetes version(s) you intend to run.
- Any add-ons in use (Azure Monitor, Azure Policy, Defender, Workload Identity, etc.).
- Any third-party FQDNs your workloads require (Helm chart repos, vendor APIs, etc.).

Cloud Services will add the required FQDN and network rules to the hub firewall policy.

> [!NOTE]
> Cluster creation will fail or hang if the hub firewall does not permit the required AKS control plane traffic before `az aks create` is run. Coordinate firewall rule additions with Cloud Services as a prerequisite, not as a follow-up.

### Workload Ingress

AKS workloads must not be exposed via public load balancer services. Two supported patterns:

1. **Internal load balancer service / internal ingress controller** — Annotate `Service` resources of type `LoadBalancer` with `service.beta.kubernetes.io/azure-load-balancer-internal: "true"`, or deploy an ingress controller (NGINX, Traefik, AGIC, etc.) configured to use an internal LB. The resulting private IP is reachable from anywhere in the managed network and from the campus network.
2. **AFD-fronted public ingress** — For workloads that must be reachable from the internet, the internal load balancer / ingress controller from pattern 1 becomes the AFD origin. Submit a Cloud Services request with the custom domain (if any), the internal hostname or IP, and any required WAF or routing rules. AFD will create a managed Private Endpoint to the load balancer, which you must approve.

For more information, see [Access Methods](../access_methods.md).

### Image Pulls and Azure Container Registry

Configure your cluster to pull images from a private Azure Container Registry with a Private Endpoint in the spoke VNet (or another reachable VNet). Attach the ACR to the cluster either by granting the kubelet identity `AcrPull` on the registry or by using `--attach-acr` at cluster creation. Ensure the ACR's Private DNS zone (`privatelink.azurecr.io`) resolves correctly from the cluster — DNS records are managed automatically in the hub Private DNS zones; contact Cloud Services if resolution fails.

If your workloads must pull from public registries (Docker Hub, quay.io, gcr.io, etc.), submit a Cloud Services request to permit the required FQDNs through the hub firewall. Consider mirroring critical public images into your private ACR to reduce dependency on internet-hosted registries and to avoid Docker Hub pull rate limits.

### Administrative Access

The private API server is not reachable from the public internet. Approved administrative access methods:

- **Azure Bastion + jump host** — Deploy or use an existing jump VM in the spoke VNet and connect via the shared hub Bastion. Run `kubectl` and `az aks` commands from the jump host.
- **Campus network / VPN** — Run `kubectl` and `az aks` commands from a workstation on the campus network or connected via Campus VPN, since the spoke VNet is reachable on its private IPs from those networks.
- **`az aks command invoke`** — Tunnels commands through the Azure control plane to the cluster, requires no direct network reachability to the API server, and is useful for break-glass access. See [Use `command invoke` to access a private cluster](https://learn.microsoft.com/en-us/azure/aks/access-private-cluster).

See [Access Methods](../access_methods.md) for the full list of approved administrative access patterns.

## Migrating

To convert an existing public AKS cluster to a privately networked configuration:

1. Plan a side-by-side migration. Most networking attributes — API server exposure, CNI mode, outbound type, and infrastructure subnets — cannot be changed in place on an existing cluster. A new cluster is generally required.
2. Coordinate with Cloud Services in advance to ensure the hub firewall permits the required AKS egress FQDNs and any workload-specific FQDNs before cluster creation.
3. Create the required subnets in your spoke VNet (node, pod if applicable, API server delegated, and optional ingress) and associate the spoke UDR and NSGs.
4. Pre-create a user-assigned managed identity for the cluster and assign the required roles on the VNet, subnets, and any private DNS zones.
5. Create the new private cluster with API Server VNet Integration, your chosen CNI mode, and `outbound_type = "userDefinedRouting"`.
6. Validate cluster bring-up: confirm nodes register, system pods reach `Running`, image pulls from ACR succeed, and egress to required FQDNs works through the hub firewall.
7. Redeploy workloads to the new cluster, switching `Service` and `Ingress` resources to internal load balancers / internal ingress controllers.
8. Validate workload connectivity from within the VNet (via a jump host through Bastion, or via campus VPN) before cutover.
9. Submit a Cloud Services request to configure AFD origins and endpoints for any workloads that must remain publicly accessible. Approve the AFD-managed private endpoint connection on the internal load balancer when prompted.
10. Update DNS records and application configurations to point at the new AFD endpoints or internal hostnames as appropriate.
11. Decommission the original public cluster once the new cluster is fully validated.

> [!NOTE]
> Cluster creation will fail if the hub firewall does not permit the required AKS control plane FQDNs at the time `az aks create` runs. Treat firewall rule additions as a hard prerequisite, not a follow-up step.

## Example Terraform Snippets

### Subnets

```hcl
resource "azurerm_subnet" "aks_nodes" {
  name                 = "snet-aks-nodes"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.x.x.x/24"]
}

resource "azurerm_subnet" "aks_pods" {
  # Only required for Azure CNI with dynamic IP allocation (pod subnet).
  name                 = "snet-aks-pods"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.x.x.x/22"]
}

resource "azurerm_subnet" "aks_apiserver" {
  # Only required for API Server VNet Integration.
  name                 = "snet-aks-apiserver"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.x.x.x/28"]

  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.ContainerService/managedClusters"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}
```

### Cluster Identity

```hcl
resource "azurerm_user_assigned_identity" "aks" {
  name                = "id-aks-workload"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = azurerm_virtual_network.spoke.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}
```

### Private AKS Cluster with API Server VNet Integration and Azure CNI Overlay

```hcl
resource "azurerm_kubernetes_cluster" "workload" {
  name                = "aks-workload"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks-workload"
  kubernetes_version  = "1.30.0"

  # Use API Server VNet Integration; the API server gets a private IP in the delegated subnet.
  api_server_access_profile {
    vnet_integration_enabled = true
    subnet_id                = azurerm_subnet.aks_apiserver.id
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "azure"
    pod_cidr            = "10.244.0.0/16"
    service_cidr        = "10.245.0.0/16"
    dns_service_ip      = "10.245.0.10"
    load_balancer_sku   = "standard"
    outbound_type       = "userDefinedRouting"
  }

  default_node_pool {
    name           = "system"
    vm_size        = "Standard_D4s_v5"
    node_count     = 3
    vnet_subnet_id = azurerm_subnet.aks_nodes.id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  depends_on = [azurerm_role_assignment.aks_network_contributor]
}
```

### Internal Load Balancer Service (Workload Ingress)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: workload
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-internal: "true"
spec:
  type: LoadBalancer
  selector:
    app: workload
  ports:
    - port: 443
      targetPort: 8443
```

The resulting internal load balancer IP is reachable from the managed network and the campus network, and can be used as the origin for an AFD endpoint configured by Cloud Services.
