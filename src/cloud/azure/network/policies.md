# Policies for the TAMU-managed Network in Azure

The overall goal of the TAMU managed Azure network initiative is to provide a secure, scalable, and manageable network architecture for TAMU workloads in Azure. To help assure a higher level of compliance and security, we leverage Azure Policy to enforce guardrails that prevent misconfigurations and non-compliant resources in our hub-and-spoke design. This document provides an overview of how policy enforcement works in our environment, the effects we use, and how they impact resource provisioning and management.

> [!NOTE]
> A policy is a set of rules that govern the properties and configurations of Azure resources.

## Policies in Use

In our TAMU-managed Azure Network environment, we primarily use the following policies:

Deny-only policies:

- **Deny public subnets**: This policy prevents the creation of subnets without being configured as private.
- **Deny public IP creation**: This policy blocks the creation of public IP addresses in customer VNets. All public IPs must be associated with a resource in the hub, such as Azure Firewall or Azure Front Door, to ensure that all traffic is properly routed and inspected.
- **Deny VNet modifications**: This policy blocks any modifications to critical VNet properties.
- **Deny public IP associations**: This policy prohibits the association of public IP addresses directly to network interfaces (NICs).
- **Deny NAT Gateway creation**: This policy prevents the creation of NAT Gateways. NAT Gateway resources are only allowed in the hub and must be configured by Cloud Services to ensure proper routing and security.
- **Deny ExpressRoute and VNet Gateway creation**: These policies prevent customers from creating ExpressRoute circuits and VNet Gateways in the hub-and-spoke peered VNets, which would interfere with our secure network design and management.

Remediation policies:

- **Enforce UDR on subnets**: This policy automatically applies a user-defined route (UDR) to any subnet that does not have one, ensuring that all outbound traffic is routed through the hub firewalls for inspection and logging. This will help to prevent misconfigurations that could lead to unexpected lack of connectivity.
- **Enforce NSG rules for public access**: This policy automatically applies NSG rules to subnets hosting public resources to restrict inbound traffic from the public internet, ensuring that only traffic from approved sources, such as Azure Front Door or the campus network, is allowed.
- **Enforce Private Endpoints for PaaS services**: This policy automatically creates and configures Private Endpoints for Azure PaaS services that require public access, such as App Service, to ensure that they are securely connected to the VNet and not exposed directly to the internet.

## How Policies Work

When a resource is created or modified, Azure Policy evaluates it against the assigned policies and their "effects" to determine if the operation should be allowed, denied, or audited. If creating or updating a resource violates a policy with a "deny" effect, the operation will be blocked, and an error message will be returned to the user in the form of a "flash" message in Azure Portal or an error in Terraform and other IaC API clients. If the policy has an "audit" effect, the operation will succeed but a non-compliance event will be logged for review. In all cases, the exact "non-compliance" message can be seen in Activity Log of the resource affected.

Some policies with "deny" effects may have a corresponding "remediation" policy that can automatically correct non-compliant resources. For example, if a subnet is created without a UDR, the "Enforce UDR on subnets" remediation policy will automatically apply the required UDR to the subnet to bring it into compliance. This helps to ensure that resources remain compliant with our security and management guidelines, even if they are initially misconfigured.
