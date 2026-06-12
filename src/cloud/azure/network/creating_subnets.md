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

* **Azure reserves 5 IP addresses in every subnet** (the first three and the last two). If you create a `/29` subnet (consuming 8 IPs total), you only have 3 <em>usable</em> addresses.
* It is easier to carve out small subnets from a sufficiently large VNet than it is to expand a spoke VNet. If the address block immediately following yours is already allocated to another customer, you may be forced to use non-contiguous blocks of addresses to expand your VNet, which is more difficult to manage, or be forced to migrate to a newly provisioned VNet.
* Use larger blocks of addresses for subnets that will host more resources or require more IP addresses, such as virtual machines, and smaller blocks for subnets that will host fewer resources, such as Azure App Service. For example, a subnet for virtual machines might use a `/24` block (256 IPs, 251 usable) while a subnet for App Service might use a `/28` block (16 IPs, 11 usable).
* Consider auto-scaling and future growth when planning subnet sizes. It is better to have unused IP addresses than to run out of addresses in a subnet.
* Know your Azure services: Some services require specifically-named subnets, some require dedicated subnets that cannot be shared with other services, and some have specific requirements for subnet size.

## Subnet Delegation, Service Endpoints, and Private Links

Subnet delegation is assigning a given subnet to a specific Azure service (like Azure SQL Managed Instance or App Service Environment). A delegated subnet can host instances only of that specific service, so you cannot add an Azure SQL Managed Instance into a subnet delegated to App Service Environment. Use this when a managed service needs to be deployed into your VNET for private connectivity.

Service Endpoints and Private Links are two different ways to privately connect to Azure PaaS services from your VNet. Service Endpoints route traffic to Azure services over the Azure backbone network while still using the service's public endpoint. They allow you to restrict service access to your VNet, but traffic still uses the public IP namespace of the service, which has security implications. Private Links provide a private IP address endpoint inside your VNet for an Azure service, allowing you to connect as if the service were a private resource within your network. Private Links are generally more secure and are the recommended approach for most scenarios.

A Private Endpoint is a network interface that uses a private IP address from your subnet to provide private connectivity to an Azure service. Unlike Service Endpoints, Private Endpoints do not require specific subnet configuration and can be placed in any subnet. This is the recommended way to connect to Azure PaaS services from your VNet. For more information on these options, see the [Microsoft documentation](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview).
  
## Route Tables and Network Security Groups (NSGs)

Subnets can be associated with route tables and NSGs to control traffic flow and security. Route tables allow you to define custom routes for traffic leaving the subnet, while NSGs allow you to define inbound and outbound security rules to control traffic to and from resources in the subnet. When designing your subnets, consider how you will use route tables and NSGs to secure your resources and control traffic flow.

<em>It is very possible that you will not need to define any route tables or NSGs for your subnets, as the default routes and security rules provided by Azure and the TAMU network design may be sufficient for your needs. One provided User-Defined Route (UDR) is pre-configured to route all outbound internet traffic from your VNet to the TAMU-managed firewall service in the hub. This ensures that all outbound traffic is inspected and filtered by the firewall, providing an additional layer of security for your resources.</em>

## Example Subnet Configurations

### Azure App Service and GitHub Private Networking

In the [GitHub deployment to Private Subnets](./github_private.md) guide, we describe and deploy a subnet design for hosting Azure App Service instances that are integrated with GitHub Private Networking. This design includes a dedicated subnet for App Service instances with the necessary delegation and private endpoint configuration to securely connect to GitHub's private network. In Terraform, these subnets might look like:

```hcl
data "azurerm_virtual_network" "spoke" {
  name                = "spoke-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  # address_space       = ["10.0.0.0/27"]
}

resource "azurerm_subnet" "workload" {
  name                 = "app-service-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.0.0.0/28"]
}

resource "azurerm_subnet" "github" {
  name                 = "github-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.0.0.16/29"]
}
```


## Referencing Your VNet in Terraform

When creating subnets or other resources that require VNet connectivity, reference the existing spoke VNet using a `data` block rather than hardcoding its values:

```hcl
# Get reference to existing vnet
data "azurerm_virtual_network" "spoke" {
  name                = "<vnet-name-not-resource-id>"
  resource_group_name = "<resource-group-name>"
}

# Reference the vnet in another resource
resource "azurerm_subnet" "workload" {
  name                 = "workload-subnet"
  resource_group_name  = data.azurerm_virtual_network.spoke.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.spoke.name
  address_prefixes     = ["<cidr-block>"]
}
```

This ensures you are using the correct VNet and avoids hardcoding values that may change. A `terraform plan` will fail early if the VNet does not exist or the name is incorrect, catching configuration errors before any resources are created.
