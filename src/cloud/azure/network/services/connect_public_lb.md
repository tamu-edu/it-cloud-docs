# Azure Load Balancers

- **Rule:** A customer workload Load Balancer (LB) must be set as internal/private and with, if required, internet ingress provided by centralized hub services.
- **Action:** Deploy the LB as "Internal" into a private subnet, and work with Cloud Services to configure ingress through the centralized hub services.

* LB must be attached to a <em>private</em> IP. (Resource options are for public or private, and public is disallowed.)
* LB subnet must have a User Defined Route (UDR) that sends outbound traffic to the hub-centralized firewall for inspection and logging.
* NSGs should follow least privilege and allow only required inbound traffic from approved sources (for example, campus network ranges, VPN, or explicitly approved private peer ranges).
* Administrative ports and management protocols must not be internet-exposed; Use approved private access methods. See [Access Methods](../access_methods.md) for details.
* For internet-facing application traffic, work with Cloud Services to configure hub-managed ingress (AFD for HTTP/S or firewall DNAT for non-HTTP/S workloads).

The load balancer works and is configured just the same for target resources. The key difference is that the LB frontend must be private/internal, and any required internet ingress must be configured through the hub.

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
