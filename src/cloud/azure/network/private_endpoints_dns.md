# Private Link

Private Link and Private Endpoint provide a way to securely connect to Azure services and your own services over a private network connection. A Private Endpoint is a network interface that connects you privately and securely to a service powered by Private Link. Private Endpoints are most commonly used for Azure PaaS services, such as Azure Storage, Azure SQL Database, and Azure Key Vault.

This allows you to access the service over a private IP address within your virtual network, rather than over the public internet, and enables many of the access methods described below.

## Private DNS

Private Link requires proper DNS resolution to function correctly. When you create a Private Endpoint, a corresponding DNS record needs to be created in a Private DNS Zone linked to the virtual networks and remote networks that need to resolve the endpoint.

In the TAMU-managed network, these Private Link DNS Zones are created and linked in the hub virtual network, and the DNS records in them are managed automatically. When you create a Private Endpoint, the corresponding DNS record group will be automatically created in the appropriate Private Link DNS Zone after a short delay. Changes to your Private Endpoints, such as the private IP address, will be synchronized automatically in the DNS records.

> [!NOTE]
> The Private Link DNS Zones and their records are managed automatically in the TAMU-managed network. You do not need to create any Private DNS zones or manage  DNS records for Private Endpoints.

If Private Link is not available or cannot be used for a particular service, a Private DNS zone will be provided specifically for your spoke virtual network for you to create and manage the necessary DNS records to enable private network access to the service.

Both the Private Link DNS Zones and any Private DNS zones provided for spoke virtual networks are resolvable from other virtual networks within the TAMU-managed Azure network and other networks when using the Infoblox DNS service. Similarly, DNS queries from the TAMU-managed Azure network will use the internal DNS view from the campus Infoblox DNS service.

The following services are currently fully supported for Private Endpoints and Private DNS within the TAMU-managed network:

- `privatelink.database.windows.net` - Azure SQL
- `privatelink.file.core.windows.net` - Azure File
- `privatelink.southcentralus.azmk8s.io` - Azure Kubernetes Service

Additional services will be added over time. Contact the Cloud Services team to request a specific service be added to the support list.
