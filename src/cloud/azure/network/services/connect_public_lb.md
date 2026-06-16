# Azure Load Balancer

- **Rule:** An Azure Load Balancer may not be deployed as a public/external load balancer directly exposing a public IP to the internet. It must be internal/private, and any required internet ingress must be routed through the centralized hub services.
- **Action:** Deploy the LB as `Internal` into a private subnet, and work with Cloud Services to configure ingress through the centralized hub services.

- Load balancer frontends must only be private/internal.
- The subnet selected for the load balancer frontend must have a User Defined Route (UDR) in order to be accessible from outside the VNet.
- Security groups should follow least privilege and allow only required inbound traffic from approved sources (for example, campus network ranges, VPN, or explicitly approved private peer ranges).
- Administrative ports and management protocols won't be internet-exposed if requested. See [Access Methods](../access_methods.md) for details.
- For internet-facing application traffic, work with Cloud Services to configure hub-managed ingress (AFD for HTTP/S or firewall DNAT for non-HTTP/S workloads).

## Implementation Pattern

Use this sequence for both new deployments and updates to existing load balancers:

1. Create or select a private subnet for the Load Balancer (LB) frontend.
1. Confirm the subnet has the default egress UDR associated to route outbound traffic through the hub firewall.
1. Deploy the LB as `"Internal"` with a private frontend IP.

If internet ingress is required, submit a Cloud Services request for hub AFD, firewall, and/or DNS updates.

## Steps in Azure Portal

The steps below are generalized for new or existing load-balanced services.

1. On Frontend IP configuration:
	 - Select your customer spoke VNet and private subnet.
	 - Set frontend type to private (internal).
	 - Do not associate a Public IP.
1. Configure backend pool reference, health probe, and load-balancing rules for your workload ports.

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
