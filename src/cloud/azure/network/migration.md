# Azure Network Migration

Over the Summer of 2026, a new network design was implemented for the TAMU managed network in Azure. This new design provides improved security and compliance for our Azure environment by centralizing traffic flow through shared Azure Front Door (AFD) with WAF rules and Azure Firewall (FW) for traffic analysis and logging. Existing Azure customers will be impacted in one or more of the following ways:

- Public resources will need to be reconfigured to be private, and the public entrypoint moved to the hub firewalls
- Connecting resources previously not connected to a VNet to the TAMU-managed network
- IP address changes, both public and private
- DNS record changes
- Outbound traffic will now be routed through the hub firewalls, which may require updates to NSG rules and route tables

Existing Azure customers not yet in this new topology need to be migrated. The migration process involves moving existing resources to a new network and/or region, as well as updating any necessary configurations.

> [!IMPORTANT]
> The TAMU managed network will only be available in the **South Central US** region at launch. Additional regions may be added.

## Migration Considerations

Many Azure services can be reconfigured to use the TAMU-managed network with minimal disruption, and you should be able to refer to the [Services Configuration](./services.md) documentation for specific configuration guidance.

The following sections outline some specific considerations for migrating resources to the new network design.

### Public Websites and Web Apps

Public-facing websites and web applications, such as those served by App Service, Container Apps, or Static Web Apps, will need to be reconfigured to be private following the guidance in the [Service Configuration](./services.md) documentation for that service. The public entry point for these services will now be a shared, managed Azure Front Door in the hub, rather than directly on the service itself.

Any resources with custom domain names will need to have their custom domain moved to the hub and configured by Cloud Services. The DNS records for the custom domain will also need to be updated to point to the new Azure Front Door endpoint.

### Resources with static public IPs

Any resources that currently have static public IP addresses, such as VMs or Application Gateways, will need to be reconfigured to be private and have their public entry point moved to the hub firewall. This may involve changing the IP address of the resource and updating any DNS records accordingly.

- If downtime can be tolerated, the existing public IP address can be disassociated from the resource then moved to the hub where it can be re-associated with the hub firewall. DNS records would not need to be changed.
- If downtime cannot be tolerated, a new public IP address will be created and configured to forward traffic to your resource, and then the DNS records can be updated to point to the new IP address.

### Migrating Regions

The TAMU managed network will only be available in specific Azure regions, and resources that need to connect to the managed network need to be located in these regions and may need to be redeployed or migrated across regions.

Resources that are stateless, or can be redeployed via Infrastructure as Code (IaC) tools or other pipelines, will be the easiest to migrate. Services that are stateful, such as those that include storage like Virtual Machines and SQL Servers, will be among the more challenging to move.

Azure provides the [Azure Resource Mover](https://learn.microsoft.com/en-us/azure/resource-mover/overview) that can help automate the process of moving resources between Azure regions. This tool can be particularly useful for migrating these stateful resources to a region where the managed network infrastructure exists.

Cloud Services can provide help and support for cross-region migrations.

## Migration Procedure

### 1. Assess which resources need to be migrated to the managed network

Consult the [Service Configuration](./services.md) documentation to identify which of your resources need to be migrated to the managed network and what specific configuration changes are required for each resource type. In general, any services which need network connectivity to make outbound connections or handle inbound connections will need to be reconfigured to use private networking and route traffic through the hub.

In some cases, you may not need to use a service any longer if its functionality can be replaced by Azure Front Door or Azure Firewall.

An important part of this migration will also be to consolidate resources into approved Azure regions where the managed network infrastructure exists.

### 2. Plan the migration

Once you know which resources need to be migrated, create a detailed migration plan that outlines the steps for each resource, the order of operations, and any dependencies between resources. This plan should include both network configuration changes and resource-specific migration steps.

Specifically, it should detail:

- **Subnet configuration for your spoke VNet**: Ensure that all subnets that will be required by your resources are accounted for and properly configured according to the new network design. This includes verifying subnet sizes, addressing any overlapping IP ranges, and ensuring that subnet-level settings align with the managed network requirements. See [creating subnets](./creating_subnets.md) for guidance.
- **Data migration to an approved Azure region**: Plan and execute the migration of data to an approved Azure region where the managed network infrastructure exists. This includes moving databases, storage accounts, and any other data resources to ensure compliance with the managed network's regional requirements.
- **Application and service configuration changes**: Identify the specific configuration changes required for each resource to connect to the managed network. This may include updating connection strings, endpoint configurations, and any other settings necessary for the resource to function correctly within the new network design.
- **Hub-side configuration changes**: Identify any configuration changes required on the hub side to support the migrated resources. This may include updating Azure Firewall rules, configuring Azure Front Door origins/endpoints, and managing Private DNS zone links to ensure proper name resolution within the managed network. Ensure these are approved and staged with Cloud Services.

### 3. Migrate resources to private networking

It is recommended to migrate resources in a phased approach, starting with creating replica instances of your resources in the new network configuration whenever possible. This allows you to validate the configuration and connectivity of the resources within the managed network before fully cutting over. Once the replicas are verified, you can proceed with migrating the primary instances and decommissioning the old ones.

- **PaaS services** (App Service, Storage Accounts, Key Vault, SQL, etc.): Configure Private Endpoints and/or Service Endpoints per the [Services Configuration](./services.md) guidance. Disable public network access on the resource once the private endpoint is validated.
- **VMs and IaaS resources**: Remove any public IP addresses from NICs. If the VM required a public IP for inbound access, work with Cloud Services to configure an inbound NAT rule or DNAT rule on the hub firewall pointing to the VM's private IP.
- **Application Gateways or Load Balancers with public IPs**: Follow the guidance in [Resources with static public IPs](#resources-with-static-public-ips) above to move the public IP to the hub, or request a new hub-managed entry point.
- **Resources using VNET integration** (e.g. App Service VNet Integration, Azure Functions): Ensure the delegated integration subnet also has the UDR applied so outbound traffic routes correctly through the hub firewall.

### 4. Update DNS configuration

The new design relies on Azure Private DNS zones managed by the hub:

- If your resource uses a private endpoint, the endpoint will be automatically registered in the corresponding Private DNS zone in the hub and will be resolvable by any internal DNS queries within the managed network, including campus.
- If your resource does not use a private endpoint, such as a VM or a resource with VNet integration, use the provided private DNS zone in your spoke VNet to create the necessary DNS records so that the resource can be resolved by its private FQDN within the managed network.

Although this is the default configuration, it is important to verify that your spoke VNet is configured to forward DNS queries to the hub resolver so that the private FQDN can be resolved correctly within the spoke VNet.

#### 5. Validate and cut over

- Coordinate with Cloud Services to deploy Firewall and Front Door configuration changes, and initiate public DNS changes, if necessary for your service.
- If using an existing spoke VNet and subnet, verify that it is properly configured as a private subnets with a user-defined route (UDR) pointing to the hub firewall. Confirm that outbound internet traffic is correctly routing after changing the subnet configuration.
- Test end-to-end connectivity for each resource from within the VNet (e.g. from a VM or using Azure Network Watcher).
- Confirm that public endpoints are no longer accessible where they have been disabled.

#### 6. Decommission legacy configuration

Once all resources are validated, remove any leftover resources no longer needed, such as old VNets, subnets, or other network components that were part of the previous configuration.

> [!IMPORTANT]
> If you are using an existing spoke VNet, ensure that the subnets are properly configured as private subnets with a user-defined route (UDR) pointing to the hub firewall, and that DNS queries are forwarded to the hub resolver. This is crucial for maintaining correct routing and name resolution within the managed network.
> Failure to do so may result in loss of connectivity and unresolved DNS queries once a strict enforcement policy is applied.
