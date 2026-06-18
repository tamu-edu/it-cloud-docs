# Creating Subnets

The purpose of this document is to explain how to create and configure subnets in a customer "spoke" Virtual Network (VNet).

## Overview

A Virtual Network (VNet) is a logical isolation of the Azure network dedicated to your subscription. Subnets are subdivisions of a VNet's address space that allow you to segment your resources for better organization, security, and performance. This document provides guidance on how to create and configure subnets within your VNet to meet your solution's requirements while adhering to best practices for security and performance. For more information on the overall TAMU managed network design, please see the [Network Design](./design.md).

Consult the Microsoft documentation [Virtual network concepts](https://learn.microsoft.com/en-us/azure/virtual-network/concepts-and-best-practices#virtual-network-concepts) and [Add, change, or delete virtual network subnets](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-subnet) for more information on virtual networks and managing subnets.

## Planning Ahead

While most VNet and subnet modifications do not require destruction and recreation, certain fundamental changes - particularly relating to IP addressing and naming - will force a delete-and-recreate action. Deleting a subnet in order to recreate it also requires first detaching, moving, or destroying resources associated with it. To avoid later complications, it is helpful to plan your Azure networking resources before deploying. The Cloud Services team can help design, plan, and configure your VNet and subnets.

* **Subnet Name:** You cannot change the name of an existing subnet (without deleting and recreating it).
* **Subnet Address Range:** If the subnet is in use (has resources attached or pointing to it), you cannot modify its IP prefix. You must detach, move, or delete all resources in the subnet, change the range, and then reattach the resources.
* **VNet Address Range (Overlapping/Shrinking):** While the range can be expanded (by Cloud Services), an address range in use by a subnet cannot be modified.

## Virtual Network (VNet) and Subnet Design

Every spoke VNet is assigned a block of IP addresses by Cloud Services from a centrally managed pool. Customers cannot select or modify the CIDR range allocated to them, so you should plan your subnet design with the assistance of Cloud Services to ensure that enough IP addresses are provided for your needs. It is important to understand the relationship between the VNet's address space, the subnets created within it, the resources and services planned to be deployed within them, and count of *usable* IP addresses in each subnet. For more information on Azure IP addressing and subnetting, see [Azure documentation](https://learn.microsoft.com/en-us/azure/virtual-network/concepts-and-best-practices#virtual-network-concepts).

When planning your subnet design, consider the following:

* **Azure reserves 5 IP addresses in every subnet** (the first three and the last two). If you create a `/29` subnet (consuming 8 IPs total), you only have 3 *usable* addresses. Plan with room to grow, as expanding a subnet later is more complex than starting with adequate space.
* Know your Azure services: Some services require specifically-named subnets, some require dedicated subnets that cannot be shared with other services, and some have specific requirements for subnet size.
* Consider auto-scaling and future growth when planning subnet sizes. It is better to have unused IP addresses than to run out of addresses in a subnet.

## Subnet Delegation, Service Endpoints, and Private Links

Some services require a dedicated subnet for their VNet integration feature, called a delegated subnet. This is common with PaaS and fully-managed services, like Azure Managed SQL or App Service Environments. A delegated subnet can host instances only of that specific service, so you cannot add an Azure SQL Managed Instance into a subnet delegated to App Service Environment. Consult the [services configuration](./services.md) document or Azure documentation to determine if this is required.

Service Endpoints and Private Links are two different ways to privately connect to Azure PaaS services from your VNet. Service Endpoints route traffic to Azure services over the Azure backbone network while still using the service's public endpoint. They allow you to restrict service access to your VNet, but traffic still uses the public IP namespace of the service, which has security implications. Private Links provide a private IP address endpoint inside your VNet for an Azure service, allowing you to connect as if the service were a private resource within your network. Private Links are generally more secure and are the recommended approach for most scenarios.

A Private Endpoint is a network interface that uses a private IP address from your subnet to provide private connectivity to an Azure service. Unlike Service Endpoints, Private Endpoints do not require specific subnet configuration and can be placed in any subnet. This is the recommended way to connect to Azure PaaS services from your VNet. For more information on these options, see the [Microsoft documentation](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview).

It is recommended that Endpoints be placed in their own dedicated subnet, separate from other resources. This allows for better security, as you can apply specific security group rules to the endpoint subnet without affecting other resources.
  
## Network Security

Network Security Groups (NSGs) are used to allow or deny inbound and outbound traffic to resources in your subnets based on source and destination IP addresses, ports, and protocols. You can use NSGs to create a layered security model for your resources, allowing you to control traffic flow at both the subnet and resource level. See [Network Security groups](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview) for more information.

When an NSG is associated with a subnet, the rules in that NSG apply to all resources within the subnet, and it is commonly used for delegated subnets or other services that do not expose individual network interface resources for more granular control. When an NSG is associated with a network interface, the rules in that NSG apply only to that specific resource.

Application security groups (ASGs) are a way to group resources together for the purpose of applying NSG rules. ASGs allow you to define a group of resources based on their function or role, and then apply NSG rules to that group instead of individual resources or entire subnets. This can simplify management and improve security by allowing you to apply consistent rules to similar resources. For example, you could create an ASG for all of your web servers, which may be distributed across multiple subnets, and apply NSG rules to them to allow inbound HTTP and HTTPS traffic while blocking other types of traffic. See [Application Security Groups](https://learn.microsoft.com/en-us/azure/virtual-network/application-security-groups) for more information.

For recommendations on designing security for your network, see the [Best practices for network security](https://learn.microsoft.com/en-us/azure/security/fundamentals/network-best-practices) guide.

## Route Tables

Route tables allow you to define custom routes for traffic leaving the subnet. Because all outbound traffic from your VNet must be inspected by the TAMU-managed firewall in the hub, a route table (UDR) named `routetable-outbound-{region}` is provided that routes all outbound traffic to the firewall.

This route table will not automatically be *pre-associated* with new subnets, and it is best practice to intentionally associate the route table with any new subnets.

> [!IMPORTANT]
> As a safeguard, Cloud Services has deployed a policy that will find subnets without a route table association and automatically apply this route table. There can be a varied and sometimes significant delay before this remediation occurs.

Most customers will not need to modify or create any additional routes. If you have specific routing requirements for your workloads, it is recommended to consult with the Cloud Services team to ensure that your routing design is compatible with the overall network architecture and security requirements.

## Example Subnet Configurations

### Basic Subnet and Default Route to Hub Firewall

The following subnet has a User-Defined Route (UDR) that directs all outbound traffic to the hub firewall.

```hcl
data "azurerm_route_table" "default_egress" {
  name                = "default-egress-route-table"
  resource_group_name = "rg-tamu-managed-network"
}

resource "azurerm_subnet" "workload" {
  name                 = "workload"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.0.0.0/28"]
}

resource "azurerm_subnet_route_table_association" "example" {
  subnet_id      = azurerm_subnet.workload.id
  route_table_id = data.azurerm_route_table.default_egress.id
}
```
