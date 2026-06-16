# Azure App Service

- **Rule:** App Services may not be exposed directly to the public internet and must be secured to private access only.
- **Action:** Deploy the App Service with public network access disabled and connect it to the spoke VNet using a Private Endpoint for inbound traffic and VNet Integration for outbound traffic through the hub firewall.

- App Service public network access must be disabled, or access restrictions configured with a default Deny rule if partial access is required.
- A Private Endpoint must be created in a private subnet of the spoke VNet to enable inbound connectivity from within the managed network.
- App Service must be connected to the VNet via VNet Integration using a dedicated delegated subnet (`Microsoft.Web/serverFarms`) with a User Defined Route (UDR) directing outbound traffic to the hub firewall.
- NSGs on the private endpoint subnet should follow least privilege and allow only required inbound traffic from approved sources (for example, campus network ranges, VPN, or the hub firewall).
- For internet-facing application traffic, work with Cloud Services to configure hub-managed ingress via the shared Azure Front Door (AFD) instance.
- Administrative access must not be internet-exposed. See [Access Methods](../access_methods.md) for details.
- App Service Plan must be on a Standard (S1) SKU or higher to support both Private Endpoints and VNet Integration.

## Implementation Pattern

You may follow the Microsoft documentation for [using Private Endpoints with App Service](https://learn.microsoft.com/en-us/azure/app-service/networking/private-endpoint) and [VNet Integration](https://learn.microsoft.com/en-us/azure/app-service/overview-vnet-integration) as references. The key points for the TAMU managed network are:

1. Create two subnets in your spoke VNet:
   - A **private endpoint subnet** for the App Service Private Endpoint.
   - A **VNet Integration subnet** delegated to `Microsoft.Web/serverFarms` for outbound traffic. This subnet must have the UDR to the hub firewall associated.
2. Deploy the App Service Plan at Standard SKU or higher, in the same region as your spoke VNet.
3. Create a **Private Endpoint** targeting the App Service, placing it in the private endpoint subnet.
4. Enable **VNet Integration** on the App Service, selecting the delegated integration subnet.
5. Set `Public network access` to `Disabled` on the App Service (or configure access restrictions with a default Deny rule if needed).
6. Verify the Private DNS zone `privatelink.azurewebsites.net` is updated with the appropriate DNS records for the Private Endpoint by performing a DNS lookup for your App Service's private FQDN and confirming it resolves to the private endpoint IP. Contact Cloud Services if it does not update.

To expose the App Service to the internet, it must be done through the centralized hub services. Submit a Cloud Services request specifying the custom domain (if any), origin hostname, and any required WAF or routing rules for the AFD configuration.

## Migrating

To convert an existing public App Service to private:

1. Create the private endpoint and VNet integration subnets if they do not already exist.
2. Add a Private Endpoint to the existing App Service targeting the new private endpoint subnet.
3. Enable VNet Integration on the App Service using the delegated integration subnet.
4. Validate connectivity from within the VNet (e.g. from a VM or via campus VPN) before disabling public access.
5. Once validated, set `Public network access` to `Disabled` (or tighten access restrictions to a default Deny).
6. Submit a Cloud Services request to configure an AFD origin and endpoint for the App Service if it needs to remain publicly accessible.
7. Update any DNS records or application configurations that previously pointed to the public App Service hostname to use the new AFD endpoint.

> [!NOTE]
> Disabling public network access will immediately block all direct inbound traffic to the App Service. Ensure the Private Endpoint and any hub-side AFD configuration are validated before making this change in production.

## Example Terraform Snippets

### Private Endpoint for App Service

```hcl
resource "azurerm_private_endpoint" "app_service" {
  name                = "pe-app-service-workload"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = "psc-app-service-workload"
    private_connection_resource_id = azurerm_linux_web_app.workload.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}
```

### VNet Integration Subnet (Delegated)

```hcl
resource "azurerm_subnet" "app_service_integration" {
  name                 = "snet-appservice-integration"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.x.x.x/28"]

  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}
```

### App Service with Private Access and VNet Integration

```hcl
resource "azurerm_service_plan" "workload" {
  name                = "asp-workload"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_web_app" "workload" {
  name                      = "app-workload"
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  service_plan_id           = azurerm_service_plan.workload.id
  public_network_access_enabled = false

  virtual_network_subnet_id = azurerm_subnet.app_service_integration.id

  site_config {}
}
```
