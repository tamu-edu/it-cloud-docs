# Policies for the TAMU-managed Network in Azure

The overall goal of the TAMU managed Azure network initiative is to provide a secure, scalable, and manageable network architecture for TAMU workloads in Azure. To help assure a higher level of compliance and security, we leverage Azure Policy to enforce guardrails that prevent misconfigurations and non-compliant resources in our hub-and-spoke design. This document provides an overview of how policy enforcement works in our environment, the effects we use, and how they impact resource provisioning and management.

> [!NOTE]
> A policy is a set of rules that govern the properties and configurations of Azure resources.

## Policies in Use

In our TAMU Secure Azure Network environment, we primarily use the following policies:
- **Deny Public Subnets**: This policy prevents the creation of subnets with public IP addresses in our spoke VNets, ensuring that all subnets are private and secure.
- **Deny VNet Modifications**: This policy blocks any modifications to critical VNet properties (while preserving the ability to create and manage subnets and peerings).
- **Deny NIC Public IP Associations**: This policy prohibits the association of public IP addresses directly to virtual machine network interfaces (NICs) in our hub-and-spoke peered VNets. If a Public IP received a request, the target host would attempt to respond but will be routed through the hub gateway and dropped by the hub firewall as an asymmetric flow.
- **Deny NAT Gateway Creation**: This policy prevents the creation of NAT Gateways in our hub-and-spoke peered VNets, ensuring that outbound traffic is properly routed through our secure architecture.
- **Deny Public IP Creation**: This policy blocks the creation of public IP addresses in our hub-and-spoke peered VNets, ensuring that all resources remain private and secure.
- **Deny ExpressRoute and VNet Gateway Creation**: These policies prevent customers from creating ExpressRoute circuits and VNet Gateways in the hub-and-spoke peered VNets, which would interfere with our secure network design and management.

## How Policy Effects Manifest

When a resource is created or modified, Azure Policy evaluates it against the assigned policies, and their "effects" to determine if the operation should be allowed, denied, or audited. If creating or updating a resource violates a policy with a "deny" effect, the operation will be blocked, and an error message will be returned to the user in the form of a "flash" message in Azure Portal or an error in Terraform and other IaC API clients. If the policy has an "audit" effect, the operation will succeed but a non-compliance event will be logged for review. In all cases, the exact "non-compliance" message can be seen in Activity Log of the resource affected.
