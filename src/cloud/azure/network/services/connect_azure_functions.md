# Azure Functions

- **Rule:** A Function App that hosts customer workload code must be connected privately to the customer spoke virtual network (VNet). HTTP triggers using anonymous authorization must have internet ingress handled through centralized hub services. HTTP triggers using function-level authorization may be directly exposed to the internet.
- **Action:** Enable VNet Integration for outbound traffic through the hub firewall. For anonymous HTTP triggers, disable public network access and use a Private Endpoint for inbound access, routing public traffic through hub AFD. For function-key-authenticated HTTP triggers, public network access may be enabled with access restrictions enforcing the function key requirement.

- Function App outbound connectivity must use VNet Integration to a dedicated delegated subnet (`Microsoft.Web/serverFarms`) with a User Defined Route (UDR) directing outbound traffic to the hub firewall.
- HTTP triggers with `anonymous` authorization must not be directly accessible from the internet. Public network access must be disabled, and internet ingress must go through hub-managed AFD.
- HTTP triggers with `function`-level authorization may be directly internet-accessible, as the function key provides authentication. Public network access may be enabled for this case.
- HTTP triggers with `admin`-level authorization must not be directly exposed to the internet under any circumstances.
- NSGs should follow least privilege and allow only required inbound traffic from approved sources (for example, campus network ranges, VPN, or the hub firewall).
- Administrative access must not be internet-exposed. See [Access Methods](../access_methods.md) for details.
- Function App Plan must be on a Flex Consumption, Premium, or Dedicated (App Service Plan) SKU to support both Private Endpoints and VNet Integration. Consumption plan does not support VNet Integration.

With the exception of anonymous HTTP triggers, your Function App triggers, bindings, deployment workflow, and runtime settings are configured as usual. The key TAMU-network differences are private inbound access and VNet-integrated outbound routing.

## Implementation Pattern

You may follow the Microsoft documentation for [using Private Endpoints with Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-create-vnet) as a reference. The key points for the TAMU managed network are:

1. Create two subnets in your spoke VNet:
   - A **private endpoint subnet** for the Function App Private Endpoint.
   - A **VNet Integration subnet** delegated to `Microsoft.Web/serverFarms` for outbound traffic. This subnet must have the UDR to the hub firewall associated.
2. Deploy the Function App on an Elastic Premium or Dedicated App Service Plan in the same region as your spoke VNet.
3. Create a **Private Endpoint** targeting the Function App, placing it in the private endpoint subnet.
4. Enable **VNet Integration** on the Function App, selecting the delegated integration subnet.
5. Set `Public network access` to `Disabled` on the Function App (or configure access restrictions with a default Deny rule if needed).
6. Verify the Private DNS zone `privatelink.azurewebsites.net` is updated with the appropriate DNS records for the Private Endpoint by performing a DNS lookup for your Function App's private FQDN from a machine inside the TAMU firewall and confirming it resolves to the private endpoint IP. Contact Cloud Services if it does not update.

## Exposing HTTP Triggers Publicly

The correct approach depends on the `authLevel` of the HTTP trigger.

### `function`-level auth — direct public exposure permitted

HTTP triggers that require a function key (`authLevel: function`) may be directly exposed to the internet, since the key provides authentication. In this case:

- Public network access on the Function App **may remain enabled**.
- No hub AFD or firewall configuration is required for inbound traffic.
- Callers must supply the function key as an `x-functions-key` header or `code` query parameter:

  ```sh
  curl -X POST "https://<func-name>.azurewebsites.net/api/<function-name>?code=<function-key>" \
    -H "Content-Type: application/json" \
    -d '{"key": "value"}'
  ```

> [!TIP]
> Store function keys in Azure Key Vault and reference them from your Function App's application settings. This allows keys to be rotated without redeployment and audited via Key Vault access logs.

> [!WARNING]
> `admin`-level authorization uses the host master key and must never be directly exposed to the internet.

### `anonymous`-level auth — hub ingress required

HTTP triggers with no authentication (`authLevel: anonymous`) must not be directly accessible from the internet. The Function App itself remains fully private with public network access disabled. All public traffic must be routed through the hub Azure Front Door, which provides WAF protection and traffic inspection. The traffic path is:

```
Internet → Azure Front Door (hub) → Private Link → Function App Private Endpoint
```

#### What to request from Cloud Services

Submit a Cloud Services request and include the following information:

- The **private FQDN** of your Function App (e.g. `func-workload.azurewebsites.net`)
- The **HTTP trigger path(s)** to be routed (e.g. `/api/my-function`, or `/api/*` for all functions)
- The desired **public hostname or custom domain** (e.g. `api.example.tamu.edu`)
- Any required **WAF exclusions or routing rules** (e.g. allowed HTTP methods, rate limits)

#### Testing the AFD-routed path

Once Cloud Services has configured the AFD origin and endpoint, test the public path from any network:

```sh
curl -X POST "https://<afd-endpoint>/api/<function-name>" \
  -H "Content-Type: application/json" \
  -d '{"key": "value"}'
```

## Testing and Running Functions Securely

With public network access disabled, functions must be invoked and monitored through private, approved channels. The following methods are all supported:

- **Local development with Azure Functions Core Tools**: Run and test functions entirely on your local machine using the [Azure Functions Core Tools CLI](https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local) (`func start`). This requires no network access to Azure and is the recommended approach during active development.
- **VS Code or IDE with Azurite**: Use the [Azure Functions extension for VS Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions) along with the [Azurite storage emulator](https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azurite) to run and debug functions locally, including trigger simulation for queue, blob, and timer triggers.
- **Campus network or VPN**: Once deployed, invoke functions directly via their private FQDN from the campus network or via the Campus VPN. The private endpoint makes the Function App reachable at its private IP from any host on the managed network.
- **Azure CLI (from campus/VPN)**: Use `az functionapp` commands to invoke functions, stream logs, and inspect configuration from any host with campus or VPN connectivity.

  ```sh
  az rest --method post \
    --url "https://<func-name>.azurewebsites.net/api/<function-name>" \
    --headers "x-functions-key=<key>"
  ```

- **Azure Portal "Test/Run" tab**: The Portal's built-in test tab works when your browser is on the campus network or VPN, since the request is proxied through the Portal to the private endpoint.
- **Deployment from CI/CD**: Deployments via GitHub Actions or Azure DevOps pipelines do not require public access to the Function App; use the [Azure Functions GitHub Action](https://github.com/Azure/functions-action) or `az functionapp deployment` CLI commands. If the pipeline needs to reach resources inside the VNet (e.g. a private storage account), configure GitHub Actions private networking per the [CI/CD Access](../access_methods.md#cicd-access) guidance.

## Steps in Azure Portal

The steps below are generalized for new or existing Function Apps.

1. Azure Portal > Function App > `Networking`.
2. Under `Outbound traffic`, configure VNet Integration to the designated delegated subnet.
3. Under `Inbound traffic`, configure a Private Endpoint targeting the private endpoint subnet.
4. In Function App `Settings` > `Configuration` (or `Environment variables`), set `Public network access` to `Disabled`.
5. Open the target subnet(s) > `Route table` and verify the hub firewall UDR is associated. See [Route Tables](../creating_subnets.md#route-tables) for details.
6. Review NSGs on the private endpoint subnet and verify only required ports and approved source ranges are allowed.

## Migrating

To migrate an existing public Function App to the managed network:

1. Create the VNet integration and private endpoint subnets if they do not already exist.
2. Enable VNet Integration on the Function App using the delegated integration subnet.
3. Review all HTTP triggers and identify their `authLevel`:
   - **`function`-level**: The trigger may remain publicly accessible. No further network change is required for inbound traffic, though adding a Private Endpoint for campus/VPN access is still recommended.
   - **`anonymous`**: The trigger must be moved behind hub AFD. Continue with steps 4–7 below.
4. Add a Private Endpoint to the Function App targeting the private endpoint subnet.
5. Validate connectivity from within the VNet (e.g. from a VM or via campus VPN) before disabling public access.
6. Submit a Cloud Services request to configure an AFD origin and endpoint for any anonymous HTTP triggers that need to remain publicly accessible.
7. Once AFD is configured and validated, set `Public network access` to `Disabled`.
8. Update any DNS records or application configurations that previously pointed to the public Function App hostname to use the new AFD endpoint.

> [!NOTE]
> Disabling public network access will immediately block all direct inbound traffic to the Function App. Ensure the Private Endpoint and any hub-side AFD configuration are validated before making this change in production.

## Example Terraform Snippets

### Function App with VNet Integration and Private Endpoint

#### Flex Consumption Plan (recommended)

```hcl
resource "azurerm_service_plan" "workload" {
  name                = "asp-func-workload"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "FC1"
}

resource "azurerm_function_app_flex_consumption" "workload" {
  name                = "func-workload"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.workload.id

  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key

  public_network_access_enabled = false
  virtual_network_subnet_id     = azurerm_subnet.func_integration.id

  runtime_name                = "node"
  runtime_version             = "20"
  maximum_instance_count      = 50
  instance_memory_in_mb       = 2048

  site_config {}
}
```

#### Elastic Premium SKU

```hcl
resource "azurerm_service_plan" "workload" {
  name                = "asp-func-workload"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "EP1"
}

resource "azurerm_linux_function_app" "workload" {
  name                = "func-workload"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.workload.id

  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key

  public_network_access_enabled = false
  virtual_network_subnet_id     = azurerm_subnet.func_integration.id

  site_config {}
}
```



### VNet Integration Subnet (Delegated)

```hcl
resource "azurerm_subnet" "func_integration" {
  name                 = "snet-func-integration"
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

### Private Endpoint for Function App (Inbound)

```hcl
resource "azurerm_private_endpoint" "func" {
  name                = "pe-func-workload"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = "psc-func-workload"
    private_connection_resource_id = azurerm_linux_function_app.workload.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}
```
