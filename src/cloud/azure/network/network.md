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
> You may be familiar with [our AWS network design](../../aws/networking.md), which shares the same goals, but each has an approach that is unique to its underlying cloud platform.

## Requirements

Not everything in Azure needs to be connected to the TAMU-managed network. Services that are considered "SaaS" (Software as a Service - such as AI Foundry or Fabric) and many fully-managed "PaaS" (Platform as a Service) offerings that won't be publicly accessible from the internet typically do not require integration with the TAMU-managed network. For a more complete list of services that are in scope for this network policy, see [Services Configuration](services.md).

Generally, an Azure service must be connected to the TAMU-managed network if it hosts, exposes, executes, or supports a workload that can receive inbound network traffic, initiate outbound network traffic, or run customer-controlled code.

Any resource that meets this criterion must be connected in such a way that all traffic to and from that resource is inspected by the approved security controls. This includes all traffic to and from the internet, as well as traffic between Azure resources and other TAMU networks.

> [!IMPORTANT]
> The TAMU managed network will only be available in the **South Central US** region at launch. Additional regions may be added.

## Using the Network

When a new Azure subscription is set up, Cloud Services provisions a spoke VNet for you in the South Central US region, or other approved region(s). VNets are allocated a default address space of `/27` (32 IP addresses) from a centrally managed pool — you cannot choose the range yourself. You are responsible for dividing this address space into subnets that fit your workloads.

### Subnets

Subnets are the primary building block you'll work with inside your spoke VNets as they define the lowest layer of organization on your network. All resources that connect to a VNet must do so within a subnet, and some Azure services have specific subnet requirements that must be considered, so careful and intentional planning of your subnet layout is essential. Cloud Services can help you with this planning.

When sizing subnets, keep in mind that **Azure reserves 5 IP addresses in every subnet**, so a `/29` (8 IPs total) leaves only 3 usable addresses. Plan with room to grow, as expanding a VNet later is more complex than starting with adequate space. VNet CIDR allocations can be adjusted by Cloud Services if the default allocation is not enough to accommodate your needs.

See [Creating Subnets](creating_subnets.md) for detailed planning guidance.

### Connecting Resources

Different types of resources have different connectivity requirements and options. Most IaaS resources can be deployed directly into your spoke VNet, while PaaS resources typically require private endpoints or service endpoints to connect securely to your VNet. We have documentation for connecting many common Azure services to the TAMU-managed network, but if you have a service that is not documented or have specific questions about how to connect your resources, please contact the Cloud Services team for assistance.

See [Services Configuration](services.md) for how to connect specific Azure services to the TAMU-managed network.

### Accessing Resources

Resources that are connected to the TAMU-managed network will not be directly accessible from the internet, so you will need to use one of the approved access methods to connect to your resources.

For IaaS resources (such as virtual machines), or PaaS services with private endpoints (such as SQL Server), you can use the campus network or Campus VPN service to connect to your resources securely on their private IP addresses.

See [Access Methods](access_methods.md) for more details on how to access your resources.

When internet access is required, such as for public web applications, you can submit a request to the Cloud Services team to set up Azure Front Door or Azure Firewall to allow secure access to your resources from the internet. See [Services Configuration](services.md) for more details on how to set this up for specific services.

## Alternatives / Exceptions

If you have a specific use case that requires a different network design or a feature or service that is not yet implemented, please contact the Cloud Engineering team to discuss your requirements. We will work with you to understand and accommodate your needs while maintaining the security and integrity of the TAMU network.

In some cases, it may be necessary to request an exception to the managed network. The office of the Chief Information Security Officer of Texas A&M University (CISO) will review your request and work with you to determine if an exception can be granted and what additional controls may be necessary to mitigate any potential risks.
