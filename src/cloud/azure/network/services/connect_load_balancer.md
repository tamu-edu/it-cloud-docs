# Azure Load Balancer

- **Rule:** An Azure Load Balancer may not be deployed as a public/external load balancer directly exposing a public IP to the internet. It must be internal/private, and any required internet ingress must be routed through the centralized hub services.
- **Action:** Deploy the LB as `Internal` into a private subnet, and work with Cloud Services to configure ingress through the centralized hub services.

- Load balancer frontends must only be private/internal.
- The subnet selected for the load balancer frontend must have a User Defined Route (UDR) in order to be accessible from outside the VNet.
- Security groups should follow least privilege and allow only required inbound traffic from approved sources (for example, campus network ranges, VPN, or explicitly approved private peer ranges).
- Administrative ports and management protocols won't be internet-exposed if requested. See [Access Methods](../access_methods.md) for details.
- For internet-facing application traffic, work with Cloud Services to configure hub-managed ingress (AFD for HTTP/S or firewall DNAT for non-HTTP/S workloads).
- Load Balancers are regional and cannot be migrated across regions.

## Implementation Pattern

### Azure Front Door

If your load balanced application is a web or other HTTP/S application and you intend to publish the application behind your load balancer to the internet, the recommended approach is to do so through the hub-managed Azure Front Door (AFD). Using this method, a private endpoint for inbound access is created and managed by AFD, and do you do not have to create or manage private DNS records or private endpoints yourself.

For more information, see [Access Methods](../access_methods.md).

### Private Endpoint for Internal/Private Access

You may follow the Microsoft example guide [Create an internal load balancer](https://learn.microsoft.com/en-us/azure/load-balancer/quickstart-load-balancer-standard-internal-portal#create-load-balancer), skipping the sections on creating NAT Gateway, VNet, and Bastion - which are provided for you in the centralized hub services.

The important points to note are:

1. You have created a private subnet for the Load Balancer (LB) in your spoke VNet.
2. Select same region for the Load Balancer as your spoke VNet.
3. Select `Internal` as the load balancer type.
4. Select the spoke VNet and the private subnet for the Load Balancer frontend.

To expose the Load Balancer to the internet, it must be done through the centralized hub services. Submit a Cloud Services request specifying the required internet ingress configuration.

## Migrating

To convert an existing public Load Balancer to private, you can add a new frontend configuration with a private subnet and update the backend pool and rules to use the new private frontend. Once the private frontend is configured and tested, the public frontend can be removed.

If the Public IP that was associated with the public Load Balancer is desired to be preserved, contact Cloud Services to coordinate the reassignment of the Public IP to the centralized hub ingress point. This may not be available if also changing regions.

It is important to plan for potential downtime and update any DNS records or application configurations that reference the public IP, as they will need to point to the new private IP or the centralized hub ingress point.

If you also need to migrate regions, you will need to recreate the Load Balancer in the new region. This involves creating a new Load Balancer in the target region, configuring the frontend, backend pools, and rules, and then updating any DNS records or application configurations to point to the new Load Balancer.

## Example Terraform Snippets

### Internal Standard Load Balancer

```hcl
resource "azurerm_lb" "workload_a" {
  name     = "lbi-workload-a"
  sku      = "Standard"
  location = azurerm_resource_group.workload.location

  frontend_ip_configuration {
    name                          = "internal-frontend"
    subnet_id                     = azurerm_subnet.private.id
    private_ip_address_allocation = "Dynamic"
  }
}
```
