# Azure Network Migration

Over the Summer of 2026, a new network design was implemented for the TAMU managed network in Azure. This new design provides improved security and compliance for our Azure environment by centralizing traffic flow through shared Azure Front Door (AFD) with WAF rules and Azure Firewall (FW) for traffic analysis and logging. Existing Azure customers will be impacted in one or more of the following ways:

- Public resources will need to be reconfigured to be private, and the public entrypoint moved to the hub firewalls
- Connecting resources previously not connected to a VNet to the TAMU-managed network
- IP address changes, both public and private
- DNS record changes
- Outbound traffic will now be routed through the hub firewalls, which may require updates to NSG rules and route tables

Existing Azure customers not yet in this new topology need to be migrated. The migration process involves moving existing resources from the old network design to the new one, as well as updating any necessary configurations.

## Migration Guide
> [!IMPORTANT]
> The TAMU managed network will only be available in the **South Central US** region at launch. Additional regions may be added.

The migration process will be carried out in phases, with each phase focusing on a specific set of resources. The following steps outline the general migration process:

1. **Assessment**: Identify the resources that need to be migrated and assess their dependencies and configurations. See [Services Configuration](../services/configuration.md) for information about which services are in scope.
2. **Planning**: Develop a migration plan that outlines the sequence of migration steps, including any downtime or service interruptions. Engage Cloud Services early in the planning phase to ensure necessary resources and support are available for migration assistance and any necessary hub resource configuration.
3. **Preparation**: Prepare the new network environment, such as creating and configuring subnets, and planning Private and/or Service Endpoints. Request and stage any necessary resources in the hub, such as AFD endpoints and FW rules, with the help of Cloud Services.
4. **Migration**: Execute the migration plan, moving resources to the new network design and updating configurations as needed. Work with Cloud Services to enable hub AFD endpoints and FW rules for the new resources and subnets as needed.
5. **Validation**: Verify that all resources are functioning correctly in the new network environment and that security policies are enforced.
6. **Decommissioning**: Decommission any previous network resources once the migration is complete and validated.
## Migration Considerations

Many Azure services can be reconfigured to use the TAMU-managed network with minimal disruption, and you should be able to refer to the [Services Configuration](./services.md) documentation for specific configuration guidance.

The following sections outline some specific considerations for migrating resources to the new network design.

### Public Websites and Web Apps

Public-facing websites and web applications, such as those served by App Service, Container Apps, or Static Web Apps, will need to be reconfigured to be private following the guidance in the [Services Configuration](./services.md) documentation for that service. The public entry point for these services will now be a shared, managed Azure Front Door in the hub, rather than directly on the service itself.

Any resources with custom domain names will need to have their custom domain moved to the hub and configured by Cloud Services. The DNS records for the custom domain will also need to be updated to point to the new Azure Front Door endpoint.

### Resources with static public IPs

Any resources that currently have static public IP addresses, such as VMs or Application Gateways, will need to be reconfigured to be private and have their public entry point moved to the hub firewall. This may involve changing the IP address of the resource and updating any DNS records accordingly.

- If downtime can be tolerated, the existing public IP address can be disassociated from the resource then moved to the hub where it can be re-associated with the hub firewall. DNS records would not need to be changed.
- If downtime cannot be tolerated, a new public IP address will be created and configured to forward traffic to your resource, and then the DNS records can be updated to point to the new IP address.

<!-- TODO: what else are we missing here? -->