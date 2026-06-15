# Azure Functions

- **Rule:** A Function App that hosts customer workload code must be connected privately to the customer spoke virtual network (VNet), with internet ingress handled through centralized hub services when required.
- **Action:** Configure private inbound access for the Function App, use VNet integration for outbound traffic through the hub firewall, and work with Cloud Services for any required internet-facing entrypoint.

* Function App inbound access should be private-only (Private Endpoint) or otherwise restricted to approved private paths.
* Function App outbound connectivity should use VNet integration to a private subnet associated with the default egress User Defined Route (UDR) to the hub-centralized firewall.
* Public network access should be disabled or tightly restricted to avoid direct public exposure.
* NSGs should follow least privilege and allow only required inbound traffic from approved sources (for example, campus network ranges, VPN, or explicitly approved private peer ranges).
* If the Function App must be reachable from the internet, work with Cloud Services to configure hub-managed ingress (AFD for HTTP/S workloads or firewall DNAT for non-HTTP/S workloads).

Generally speaking, your Function App triggers, bindings, deployment workflow, and runtime settings are configured as usual. The key TAMU-network differences are private inbound access, VNet-integrated outbound routing, and hub-managed internet ingress.

## Implementation Pattern

Use this sequence for both new Function App deployments and updates to existing Function Apps:

1. Create or select the required private subnets:
	 - One subnet for Function App VNet integration (delegated as required).
	 - One subnet for private endpoints, if used.
2. Confirm VNet integration subnet has the default egress UDR associated to route outbound traffic through the hub firewall.
3. Create or update the Function App and enable VNet integration to the designated subnet.
4. Configure private inbound access (for example, Private Endpoint) and disable or restrict public network access.
5. Validate private connectivity to triggers/dependencies and runtime health from approved networks.

If internet ingress is required, submit a Cloud Services request for hub AFD, firewall, and/or DNS updates.

> [!NOTE]
> If your Function App needs to be run from the Dashboard in Azure Portal, it may require temporary public access during development and testing.

## Steps in Azure Portal

The steps below are generalized for new or existing Function Apps.

1. Azure Portal > Function App > Networking.
1. Under `Outbound traffic`, configure VNet integration to the designated private subnet.
1. Under `Inbound traffic`, configure private inbound access (for example, Private Endpoint).
1. In Function App `Configuration`, set public network access to disabled or apply default `Deny` access restrictions.
1. Open target subnet(s) > Route table and verify the hub firewall UDR is associated. See [Route Tables](../creating_subnets.md#route-tables) for details.
1. Review NSGs and verify only required ports and approved source ranges are allowed.

## Example Terraform Snippets

### Function App with VNet Integration (Outbound) and Access Restrictions (Inbound)

```hcl
resource "azurerm_linux_function_app" "workload" {
	...

	storage_account_name       = azurerm_storage_account.sa.name
	storage_account_access_key = azurerm_storage_account.sa.primary_access_key

	virtual_network_subnet_id = azurerm_subnet.func_integration.id

	site_config {
		ip_restriction_default_action = "Deny"

		ip_restriction {
			name       = "allow-hub"
			action     = "Allow"
			priority   = 100
			ip_address = var.hub_ingress_cidr
		}
	}
	...
}
```

### Private Endpoint for Function App (Inbound)

```hcl
resource "azurerm_private_endpoint" "func" {
  ...

	private_service_connection {
		name                           = "psc-func-workload"
		private_connection_resource_id = azurerm_linux_function_app.workload.id
		subresource_names              = ["sites"]
		is_manual_connection           = false
	}
}
```
