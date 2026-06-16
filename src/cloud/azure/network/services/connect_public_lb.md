# Azure Load Balancer

- **Rule:** An Azure Load Balancer may not be deployed as a public/external load balancer directly exposing a public IP to the internet. It must be internal/private, and any required internet ingress must be routed through the centralized hub services.
- **Action:** Deploy the LB as `Internal` into a private subnet, and work with Cloud Services to configure ingress through the centralized hub services.

- Load balancer frontends must only be private/internal.
- The subnet selected for the load balancer frontend must have a User Defined Route (UDR) in order to be accessible from outside the VNet.
- Security groups should follow least privilege and allow only required inbound traffic from approved sources (for example, campus network ranges, VPN, or explicitly approved private peer ranges).
- Administrative ports and management protocols won't be internet-exposed if requested. See [Access Methods](../access_methods.md) for details.
- For internet-facing application traffic, work with Cloud Services to configure hub-managed ingress (AFD for HTTP/S or firewall DNAT for non-HTTP/S workloads).

## Implementation Pattern

You may follow the Microsoft example guide [Create an internal load balancer](https://learn.microsoft.com/en-us/azure/load-balancer/quickstart-load-balancer-standard-internal-portal#create-load-balancer), skipping the sections on creating NAT Gateway, VNet, and Bastion - which are provided for you in the centralized hub services.

The important points to note are:

1. You have created a private subnet for the Load Balancer (LB) in your spoke VNet.
2. Select same region for the Load Balancer as your spoke VNet.
3. Select `Internal` as the load balancer type.
4. Select the spoke VNet and the private subnet for the Load Balancer frontend.

To expose the Load Balancer to the internet, it must be done through the centralized hub services. Submit a Cloud Services request specifying the required internet ingress configuration.

## Example Terraform Snippets

### Internal Standard Load Balancer (Private Frontend)

```hcl
resource "azurerm_lb" "workload" {
  ...

	frontend_ip_configuration {
		name                          = "private-frontend"
		subnet_id                     = azurerm_subnet.workload.id
		private_ip_address_allocation = "Dynamic"
	}
}
```
