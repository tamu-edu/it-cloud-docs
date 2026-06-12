# Texas A&M Azure Network

The Technology Services Cloud Services team provides all Azure customers access to a managed network built within the Texas A&M University Azure environment. This network was designed to meet the technical needs of Azure customers while implementing the security features required by TAMU and state law, such as [SC-7 Boundary Protection](https://docs.security.tamu.edu/docs/security-controls/SC/SC-7/). The network design is based on Azure best practices and is regularly reviewed and updated to ensure it meets the evolving needs of our customers and the security requirements of TAMU.

## Network Overview

All Technology Services Azure customers are provided with their own Virtual Networks (VNets), called "spoke networks", in one or more Azure regions, that can be used when deploying resources that require VNet connectivity. These spoke networks are connected to a "hub network" managed by the Cloud Services team, that provides secure access to the internet, shared services, and other TAMU networks, such as the campus network.

Like the campus network, the Azure network is designed to be highly available, resilient, and scalable, allowing you to easily add or remove resources as needed without having to worry about the underlying infrastructure. It is also designed to be secure by default, with controls and approval processes in place to ensure that your resources are protected from unauthorized access and that your data is secure.

To achieve these goals, the Azure network is designed with the following key features:

- **Centralized Ingress/Egress**: All inbound and outbound traffic to and from the internet is routed through a centralized set of services in the hub VNet, such as Azure Front Door and Azure Firewall, that are managed by the Cloud Services team. This allows for consistent security policies to be applied to all traffic and for better monitoring and logging of network activity.
- **Network Segmentation**: Security groups are configured to block all inbound traffic by default. This means that resources in the spoke VNets are not directly accessible by other networks, and that all inbound traffic must be explicitly allowed. This helps to reduce the attack surface of your resources and to prevent unauthorized access.

Because of these features and the network design, the process for creating and configuring resources in your Azure environment will be different than what you may be used to in other Azure environments without a managed network. Refer to the [Azure Network Design](design.md) page for more details about the network design and how to work with it when deploying your resources. If you have any questions or need assistance with designing your network architecture, please contact the Cloud Services team for guidance and support.

> [!NOTE]
> You may be familiar with [our AWS network design](https://docs.cloud.tamu.edu/cloud/aws/networking.html), which shares the same goals, but each has an approach that is unique to its underlying cloud platform.













## Exception Request

If you have a specific use case that requires a different network design, please contact the Cloud Services team to discuss your requirements. We will work with you to understand your needs while maintaining the security and integrity of the TAMU network.


## Reference

### Using VNet in Terraform

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

Note that it is not strictly necessary to reference the vnet in a data block like this, but it is a best practice to do so to ensure that you are using the correct vnet and to avoid hardcoding values that may change in the future. A tfplan will fail early if the vnet does not exist or if the name is incorrect, which can save time and prevent errors later.
