# Azure Network Migration

Over the Summer of 2026, a new network design was implemented for the TAMU Azure Virtual Networks (VNets). This new design includes a hub-and-spoke architecture, which provides improved security and scalability for our Azure environment by centralizing traffic flow through shared Azure Front Door (AFD) with WAF rules and Azure Firewall (FW) for traffic scanning and logging. The changes affecting customers include new Virtual Network (VNet) and address allocation, requirements of securing subnets and resources to private, and directing public resources through the hub gateways for inbound and outbound traffic.

Existing Azure customers not yet in this new topology need to be migrated. The migration process involves moving existing resources from the old network design to the new one, as well as updating any necessary configurations.

## Migration Guide

The migration process will be carried out in phases, with each phase focusing on a specific set of resources. The following steps outline the general migration process:

1. **Assessment**: Identify the resources that need to be migrated and assess their dependencies and configurations.
2. **Planning**: Develop a migration plan that outlines the sequence of migration steps, including any downtime or service interruptions. Engage Cloud Services early in the planning phase to ensure necessary resources and support are available for migration assistance and any necessary hub resource configuration.
3. **Preparation**: Prepare the new network environment, including requesting the new VNet to be provisioned, creating and configuring subnets, and planning Private Endpoints, etc. for certain services.
4. **Migration**: Execute the migration plan, moving resources to the new network design and updating configurations as needed. Work with Cloud Services to prepare identified hub AFD Endpoint and FW rules for the new resources and subnets as needed.
5. **Validation**: Verify that all resources are functioning correctly in the new network environment and that security policies are enforced.
6. **Decommissioning**: Decommission the old network environment once the migration is complete and validated.

### App Services

- **Rule:** App Services may not be exposed to the public internet and must be secured to private access only.
- **Action:** This can be achieved by using Private Endpoints to connect App Services to the VNet and ensuring that all inbound and outbound traffic is directed through the hub gateways for security scanning and logging.

* App Service "Public Access" property must be either set to "Disabled" or "Enabled with Limited Access" together with a default Deny rule in order to prevent direct public access.
* App Service must be connected to the VNet via a private subnet with a User Defined Route (UDR) directing outbound traffic to the hub firewall and with no NSG rules allowing inbound traffic from the public internet.

## Custom Domains
* Custom domains do not need to be on the App Service (for example) but instead must be configured in the hub by Cloud Services. In response, the customer will be provided an Azure Public DNS zone and records to configure in their spoke environment.

### Virtual Machines

- **Rule:** Virtual Machines (VMs) must be secured to private access only.
- **Action:** This can be achieved by placing VMs in private subnets with User Defined Routes (UDRs) directing outbound traffic to the hub firewall and with no NSG rules allowing inbound traffic from the public internet. If public access is required, it must be directed through the hub.

### Database Services

- **Rule:** Database services must be secured to private access only.
- **Action:** Set "Enable Public Access" to "Disabled" and connect to the VNet via a private subnet. Configure a Private Endpoint to connect to the database service.
