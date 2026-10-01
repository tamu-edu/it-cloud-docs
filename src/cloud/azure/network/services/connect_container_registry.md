# Securing Azure Container Registry (Public Instances)

- **Rule:** Public Azure Container Registries (ACR) must enforce authenticated access and restrict permissions.
- **Action:** Configure ACR with authenticated access, scoped permissions, and disabled anonymous pulls.

- Authenticated access should be enforced for all public ACR instances.
- Pull access should be restricted to authenticated identities (e.g., managed identities with `AcrPull` role).
- Push access should be limited to CI/CD identities with the `AcrPush` role.
- Network access should be controlled at the workload egress level rather than at the ACR perimeter.

## Implementation Pattern

### Public ACR (Standard SKU)

_ACR Standard SKU does not support Private Link or VNet integration. This guide focuses on securing **public** ACR instances with authenticated access._

The standard pattern for ACR in the TAMU managed network is a public registry with authenticated and granular, scoped access enforced. The ACR remains publicly accessible but not anonymously.

## Migrating

To convert an existing public ACR deployment to secure access:

1. Disable the admin account (`admin_enabled = false`) and anonymous pulls (`anonymous_pull_enabled = false`).
2. Restrict pull access to authenticated identities (e.g., managed identities with `AcrPull` role).
3. Limit push access to CI/CD identities with the `AcrPush` role.
4. Validate connectivity from CI/CD pipelines.

## Example Terraform Snippets

### Public ACR with Secure Access

```hcl
resource "azurerm_container_registry" "acr" {
  name                = "myregistry"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Standard selected for this example, but Premium is of course permissible.
  # Standard does not support Private Link or ACR-side network rules.
  sku = "Standard"

  # Disable admin account (legacy username/password auth).
  admin_enabled = false

  # Public endpoint remains enabled by design because this is Standard SKU.
  public_network_access_enabled = true

  # Disable anonymous image pulls.
  anonymous_pull_enabled = false
}
```

### Example: Assign ABAC roles to a managed identity for pulls

```hcl
resource "azurerm_role_assignment" "acr_repo_reader" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "Container Registry Repository Reader"
  principal_id         = azurerm_user_assigned_identity.pull_identity.principal_id
}
```

### Example: Assign ABAC role to a GitHub OIDC service principal for pushes

```hcl
resource "azurerm_role_assignment" "acr_repo_contributor" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "Container Registry Repository Contributor"
  principal_id         = data.azuread_service_principal.github_oidc.id
}
```
