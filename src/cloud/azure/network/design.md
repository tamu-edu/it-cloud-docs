# Azure Network Design

Texas state law and Texas A&M University policies require that all TAMU networks be protected by a secure, managed boundary, and thus resources on those networks may not be directly accessible from the public internet. To meet these requirements, the TAMU-managed network in Azure is designed with a hub-and-spoke topology that centralizes traffic flow through shared Azure Front Door (AFD) with WAF rules and Azure Firewall (FW) for traffic analysis and logging.

## Design Overview

Cloud Services operates and manages the hub network, including the shared AFD and FW services, while customers are responsible for their own spoke networks and resources. The following diagram illustrates the overall network design and traffic flow for the TAMU-managed network in Azure.


```mermaid
flowchart TB
    internet_in(["🌐 Internet (ingress)"])

    subgraph afd["Azure Front Door (Global)"]
        direction TB
        fd_waf["WAF Policy<br>(Geo-block · Bot · OWASP)"]
        fd_lb["Layer-7 LB<br>(Hostname + Path Routing<br>TLS Termination)"]
        fd_waf --> fd_lb
    end

    %% Ingress: HTTP/HTTPS via Front Door
    internet_in -->|"HTTP/HTTPS"| afd
    fd_lb -- Private origin<br>(HTTPS) --> svc_a1
    fd_lb -- Private origin<br>(HTTPS) --> svc_b1

    %% Ingress: TCP/UDP via Firewall DNAT
    internet_in -->|"TCP/UDP"| fw
    fw -->|"DNAT private IP"| svc_a2
    fw -->|"DNAT private IP"| svc_b2


    subgraph hub["HUB VNet - Cloud Team"]
        direction TB
        fw["Azure Firewall<br>(Inspection · DNAT · Egress)"]
        nat["NAT Gateway"]
        gw["ExpressRoute"]
        fw --> nat
        fw ~~~ gw
    end

    subgraph spoke_a["Spoke VNet — Customer A"]
        svc_a1["Private Service<br>(App Service / App Gateway)"]
        svc_a2["Private Service<br>(VM / Container)"]
    end

    subgraph spoke_b["Spoke VNet — Customer B"]
        svc_b1["Private Service<br>(App Service / App Gateway)"]
        svc_b2["Private Service<br>(VM / Container)"]
    end
    
    wan(["🏛️ Campus / WAN"])
    internet_out(["🌐 Internet (egress)"])


    %% Spoke → HUB peering (egress / response)
    %% svc_a1 & svc_a2 <-- VNet Peering --> fw
    %% svc_b1 & svc_b2 <-- VNet Peering --> fw
    
    %% Egress to internet
    spoke_a -->|"Default Route"| fw
    nat -->|"Outbound internet"| internet_out
    spoke_b -->|"Default Route"| fw

    %% WAN connectivity
    gw <--> wan
    spoke_a <--> gw
    spoke_b <--> gw
```

> [!NOTE]
> **Key:**
> All _inbound_ internet traffic enters through Azure Front Door (HTTP/HTTPS) or Azure Firewall DNAT (TCP/UDP). All _outbound_ internet traffic exits through Azure Firewall and NAT Gateway. Customer spoke VNets have no direct internet path. WAN connectivity (campus networks, other clouds) is provided through the HUB via ExpressRoute or VPN Gateway.

External internet ingress is provided by a highly available Azure Front Door and/or Azure Firewall service that is managed by the Cloud Services team. These services provide security and access control for all resources in the VNet and integrate seamlessly with existing Azure security services, such as Network Security Groups (NSGs). Traffic is routed appropriately based on the type of traffic and the resources being accessed. For example, HTTP/HTTPS traffic is routed through Azure Front Door, while other TCP/UDP traffic is routed through Azure Firewall to the appropriate resources in the spoke VNets.

Pre-configuration, defaults, and Azure Policy help to ensure that your network resources comply with TAMU's security and management guidelines. If you need to claim an exception for your resources, please contact the Cloud Services team for assistance.

- **Public Subnets**: Directly public subnets are disallowed in this configuration. For resources that need to be accessible from the internet, private subnets are linked to Azure Front Door and Azure Firewall on the hub VNet. Additionally, you can add Azure Private Endpoints to secure inbound access to Azure PaaS services from private subnets.
- **Private Subnets**: The default state of subnets in this network design. These subnets are used for resources that are not directly accessible from the internet.
- **Dedicated Subnets**: Subnets should be, and in some cases must be, dedicated to a specific purpose or resource type, such as a subnet for virtual machines, a subnet for databases, etc. This helps to improve security and manageability of your resources. See [Deploying to a Private Subnet with GitHub Actions](./github_private.md) guide for an example.

See [Creating Subnets](./creating_subnets.md) for more information and guidance on how to create and configure subnets within your TAMU Cloud Services-provisioned VNet.

Finally, internet egress is routed from the customer spoke subnets through the same Azure Firewall and NAT Gateway services back to the requesting client.

Note: Requests originating from Azure Front Door enter the private subnet via Private Link: responses return via the same path and do not traverse the hub Firewall in order to avoid asymmetric routing.


## Private Connectivity to TAMU

TAMU has redundant ExpressRoute connections to Azure that provide a private, high-speed, low-latency connection to the Azure cloud. This connection is used to provide secure, private access between the TAMU campus network and Azure.

In general, it is recommended to use the internet to access resources in Azure. Use of this private connectivity is not recommended except when architecturally necessary. Instead, consider trying to decouple your resources depending on the campus networks and utilize alternatives that are already in the cloud, or extending that resource into the cloud. This will also help to reduce the risk of a single point of failure for your service.
