# Azure Container Apps

- **Rule:** Azure Container Apps environments may not be exposed directly to the public internet and must be deployed in **internal-only** mode within the spoke VNet.
- **Action:** Deploy a Container Apps environment with VNet integration in **internal** mode using a dedicated subnet in the spoke VNet, with outbound traffic routed through the hub firewall, and use a Private Endpoint or hub-managed AFD for ingress.

- The Container Apps environment must be created with `internal_load_balancer_enabled = true` (the **internal** networking mode) so the environment receives a private IP only.
- A dedicated subnet must be provided for the environment. The minimum subnet size depends on the workload profile type — see [Networking in Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/networking) for current minimums (typically `/27` for Consumption-only and `/23` for workload profiles environments).
- The environment subnet must have a User Defined Route (UDR) directing outbound traffic (`0.0.0.0/0`) to the hub firewall. Container Apps supports UDR on workload profiles environments; verify your environment type supports the UDR configuration you require.
- NSGs on the environment subnet must permit the platform traffic required by Container Apps (see [NSG allow rules](https://learn.microsoft.com/en-us/azure/container-apps/firewall-integration)) in addition to your application's inbound traffic from approved sources.
- For inbound private access from within the managed network, use a Private Endpoint targeting the managed environment, or rely on the environment's internal load balancer IP if Private Endpoint is not required.
- For internet-facing application traffic, work with Cloud Services to configure hub-managed ingress via the shared Azure Front Door (AFD) instance using a Private Endpoint to the Container Apps environment.
- Container images should be pulled from a private Azure Container Registry with a Private Endpoint where possible.
- Administrative access (console, log streaming) traverses the Azure control plane and does not require public network exposure on the environment itself. See [Access Methods](../access_methods.md) for details.

## Implementation Pattern

### Azure Front Door

If you intend to publish your container app to the internet, the recommended approach is to do so through the hub-managed Azure Front Door (AFD). AFD supports Container Apps environments as a Private Link origin, so a managed private endpoint will be created by AFD and must be approved by you on the environment before traffic flows.

When using AFD-managed private endpoints, only AFD can access your environment over that private endpoint, and internet-facing traffic must go through AFD. Internal/private traffic from other resources or networks will continue to use the environment's internal load balancer IP or a separately provisioned Private Endpoint.

For more information, see [Access Methods](../access_methods.md).

### Internal Container Apps Environment with Private Endpoint

The standard pattern in the TAMU managed network is a Container Apps environment created in **internal** mode in a dedicated subnet of the spoke VNet, with outbound traffic forced through the hub firewall, and inbound access provided either by the environment's internal load balancer IP or via a Private Endpoint.

You may follow the Microsoft documentation for [networking in Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/networking) and [providing a virtual network to an internal Container Apps environment](https://learn.microsoft.com/en-us/azure/container-apps/vnet-custom-internal) as references. The key points for the TAMU managed network are:

1. Create a dedicated subnet in your spoke VNet sized appropriately for the environment type (workload profiles or Consumption-only). Refer to the Microsoft documentation for current minimum sizes.
2. Associate the spoke's UDR (which routes `0.0.0.0/0` to the hub firewall) with the environment subnet. Confirm the environment type supports UDR for your scenario.
3. Apply an NSG to the environment subnet that permits the [required Container Apps platform traffic](https://learn.microsoft.com/en-us/azure/container-apps/firewall-integration) plus the inbound traffic your application requires from approved sources.
4. Create the managed environment with `internal_load_balancer_enabled = true` and reference the dedicated subnet via `infrastructure_subnet_id`.
5. Deploy your container apps into the environment. Apps with `ingress { external_enabled = false }` are reachable only from within the VNet via the environment's internal load balancer; apps with `external_enabled = true` are still only reachable on the environment's private IP because the environment is internal.
6. (Optional but recommended) Create a Private Endpoint targeting the managed environment for cleaner DNS-based private access. Select `No` when prompted to integrate with a private DNS zone — DNS records will be created automatically in the private DNS zone in the hub VNet.
7. Verify the Private DNS zone for Container Apps is updated with the appropriate DNS records by performing a DNS lookup for your app's FQDN and confirming it resolves to the private IP. Contact Cloud Services if it does not update.

To expose a container app to the internet, it must be done through the centralized hub services. Submit a Cloud Services request specifying the custom domain (if any), the Container Apps environment, the target app's FQDN, and any required WAF or routing rules for the AFD configuration. AFD will create a managed Private Endpoint to the environment which you must approve.

## Migrating

To convert an existing public/external Container Apps environment to private:

1. Create the dedicated environment subnet in your spoke VNet if it does not already exist, and associate the hub firewall UDR and required NSG.
2. Deploy a new Container Apps environment in **internal** mode (`internal_load_balancer_enabled = true`) referencing the new subnet. Container Apps environments cannot be converted between external and internal modes in place — a new environment is required.
3. Redeploy your container apps into the new internal environment. Reuse your existing container images and revision configuration where possible.
4. Validate connectivity from within the VNet (e.g. from a VM, via Azure Bastion, or via campus VPN) before decommissioning the original environment.
5. Submit a Cloud Services request to configure an AFD origin and endpoint for the new environment if the workload needs to remain publicly accessible. Approve the AFD-managed private endpoint connection on the new environment when prompted.
6. Update any DNS records or application configurations that previously pointed to the original environment's public FQDN to use the new AFD endpoint or the new internal FQDN as appropriate.
7. Decommission the original external environment once the new internal environment is fully validated.

> [!NOTE]
> Container Apps environments are immutable with respect to networking mode (internal vs. external) and the infrastructure subnet. Plan for a side-by-side migration rather than an in-place change, and coordinate cutover timing with Cloud Services if AFD reconfiguration is required.

## Example Terraform Snippets

### Environment Subnet

```hcl
resource "azurerm_subnet" "container_apps" {
  name                 = "snet-containerapps"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.x.x.x/23"] # /23 for workload profiles, /27 for Consumption-only
}
```

### Internal Container Apps Environment

```hcl
resource "azurerm_log_analytics_workspace" "workload" {
  name                = "law-containerapps-workload"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "workload" {
  name                       = "cae-workload"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workload.id

  infrastructure_subnet_id       = azurerm_subnet.container_apps.id
  internal_load_balancer_enabled = true

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }
}
```

### Container App with Internal Ingress

```hcl
resource "azurerm_container_app" "workload" {
  name                         = "ca-workload"
  container_app_environment_id = azurerm_container_app_environment.workload.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "app"
      image  = "myregistry.azurecr.io/workload:latest"
      cpu    = 0.5
      memory = "1.0Gi"
    }
  }

  ingress {
    external_enabled = false # Reachable only via the environment's internal LB
    target_port      = 8080
    transport        = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}
```

### Private Endpoint for the Managed Environment (Optional)

```hcl
resource "azurerm_private_endpoint" "container_apps" {
  name                = "pe-cae-workload"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = "psc-cae-workload"
    private_connection_resource_id = azurerm_container_app_environment.workload.id
    subresource_names              = ["managedEnvironments"]
    is_manual_connection           = false
  }
}
```