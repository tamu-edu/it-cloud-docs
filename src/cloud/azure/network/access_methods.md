# Accessing Resources

Resources that are connected to the TAMU-managed network will not be directly accessible from the internet, so you will need to use one of the approved access methods to connect to your resources. For administrative access to virtual machines specifically, a shared Azure Bastion service is provided in the hub VNet and is available to all spokes by default.

## Access Methods

These access methods will vary based on the type of resource and the connectivity options it supports, but may include:

- **Campus Network**: You can connect to most resources securely on their private IP addresses from the campus network or via the Campus VPN service.
- **Azure Front Door**: For web applications or static web content that need to be accessible from the internet, Azure Front Door can be used to provide secure, global access with features like SSL termination, Web Application Firewall, and DDoS protection. This is the recommended access method for public web content.
- **Azure Firewall**: For other types of resources that need to be accessible from the internet, Azure Firewall can be used to provide secure access while still allowing for inspection and control of traffic.
- **Azure Bastion**: For administrative access (RDP/SSH) to virtual machines, the shared hub-managed Azure Bastion service provides secure, browser-based connectivity without requiring public IPs on your VMs or a VPN connection.

## Private Link & Private Endpoint

Private Link and Private Endpoint provide a way to securely connect to Azure services and your own services over a private network connection. A Private Endpoint is a network interface that connects you privately and securely to a service powered by Private Link. Private Endpoints are most commonly used for Azure PaaS services, such as Azure Storage, Azure SQL Database, and Azure Key Vault.

This allows you to access the service over a private IP address within your virtual network, rather than over the public internet, and enables many of the access methods described below.

### Private DNS

Private Link requires proper DNS resolution to function correctly. When you create a Private Endpoint, a corresponding DNS record needs to be created in a Private DNS Zone linked to the virtual networks and remote networks that need to resolve the endpoint.

In the TAMU-managed network, these Private Link DNS Zones are created and linked in the hub virtual network, and the DNS records in them are managed automatically. When you create a Private Endpoint, the corresponding DNS record group will be automatically created in the appropriate Private Link DNS Zone after a short delay. Changes to your Private Endpoints, such as the private IP address, will be synchronized automatically in the DNS records.

> [!NOTE]
> The Private Link DNS Zones and their records are managed automatically in the TAMU-managed network. You do not need to create any Private DNS zones or manage  DNS records for Private Endpoints.

If Private Link is not available or cannot be used for a particular service, a Private DNS zone will be provided specifically for your spoke virtual network for you to create and manage the necessary DNS records to enable private network access to the service.

Both the Private Link DNS Zones and any Private DNS zones provided for spoke virtual networks are resolvable from other virtual networks within the TAMU-managed Azure network and other networks when using the Infoblox DNS service. Similarly, DNS queries from the TAMU-managed Azure network will use the internal DNS view from the campus Infoblox DNS service.

The following services are enabled for Private DNS within the TAMU-managed network:

- Azure Storage
- Azure SQL Database
- Azure Key Vault
- TODO: check the forwarding rules in Infoblox and complete this list. Ensure they're added to the Private DNS DINE policy.

Contact the Cloud Services team to request additional services to be enabled for Private DNS.

## Campus Network Access

The TAMU managed network in Azure is connected to the campus network by a private, high-speed connection, so you can access your resources securely on their private IP addresses from the campus network or via the Campus VPN service. This is the current recommended access method for most resources, as it provides secure, private connectivity without exposing your resources to the public internet.

You will need to create security group rules to allow this traffic, since all inbound traffic is blocked by default. Best practice is to create rules that follow the principle of least privilege, allowing only the necessary traffic from the campus network to your resources.

To allow all traffic from the campus network and other trusted networks, you can create a rule with the following properties:

| Source | Source Port Ranges | Destination | Service | Destination Port Ranges | Protocol | Action  |
|--------|--------------------|-------------|---------|-------------------------|----------|---------|
| `Any`  | `*`                | `Any`       | `Any`   | `*`                     | `Any`    | `Allow` |

> [!IMPORTANT]
> This rule allows all traffic from the campus network and other trusted networks, so it should be used with caution and only if you have other controls in place to protect your resources, such as encryption, strong authentication, and monitoring. It is recommended to create more specific rules that only allow the necessary traffic to your resources.

## Azure Front Door

If your resource is a web application, static web content, or other HTTP/S-based service that needs to be accessible from the internet, Cloud Services operates a shared instance of Azure Front Door that can be used to provide secure, global access with features like SSL termination, Web Application Firewall, and DDoS protection. This is the recommended access method for public web content.

Use the [Services Configuration](services.md) guide to set up your origin service, such as App Service, App Gateway, or internal Load Balancer, then contact the Cloud Services team to configure Azure Front Door.

Azure Front Door will create a managed private endpoint for your origin service using Private Link, which must be accepted by you in your origin configuration before traffic can flow from Azure Front Door to your origin service.

See the [Supported Origins](https://learn.microsoft.com/en-us/azure/frontdoor/private-link#supported-origins) for Azure Front Door Private Link for more information on which types of origin services can be used with Azure Front Door and Private Link and how to accept the private link connection request for your origin services.

## Azure Firewall

For other types of resources that need to be accessible from the internet, Azure Firewall can be used to provide secure access while still allowing for inspection and control of traffic. This is typically used for non-web workloads that still require some level of public accessibility. Use the [Services Configuration](services.md) guide to set up your resource then contact the Cloud Services team to configure Azure Firewall for secure access.

> [!WARNING]
> Administrative protocols, such as RDP, SSH, or any protocols without TLS encryption, will not be opened to the internet through Azure Firewall. For administrative access to virtual machines, use the shared hub Azure Bastion service (see [Azure Bastion](#azure-bastion) below). For other administrative access, use the campus network or VPN. If you have a specific use case that requires administrative access from the internet, please contact the Cloud Services team to discuss your requirements and potential solutions.

## CI/CD Access

Some customers are using CI/CD workflows or other automated processes to deploy resources to Azure. The Azure Resource Manager (ARM) API is accessible from the internet, so you can deploy resources to your Azure subscription and VNet from any location with internet access, including from GitHub Actions or other CI/CD platforms. No additional access is required for this.

However, if your CI/CD workflow needs to access resources in your VNet (for example, to publish or test a web application to a private App Service, or to access a private database), you will need additional configuration to connect to those resources securely.

### GitHub Actions

For customers using GitHub, GitHub Actions can be configured to access your TAMU managed network spoke VNet through a private endpoint. This allows GitHub to securely access external resources, such as package registries and other services, while keeping the GitHub instance itself isolated from direct internet access. The GitHub "Organization" and your target VNet will need one-time configuration for this with assistance from Cloud Services, and your workflow action yml(s) will need to be updated accordingly.

#### Configure Your VNet

GitHub requires a dedicated, delegated subnet in your VNet to connect securely. The minimum size for this subnet is `/29`, which provides 6 usable IP addresses for GitHub runners. Size this subnet according to your anticipated usage, as each concurrent workflow job will require an IP address for the runner. See [GitHub documentation](https://docs.github.com/en/organizations/managing-organization-settings/configuring-private-networking-for-github-hosted-runners-in-your-organization#:~:text=To%20determine%20the%20appropriate%20subnet%20IP%20address%20range%2C%20we%20recommend%20adding%20a%2030%25%20buffer%20to%20the%20maximum%20job%20concurrency%20you%20anticipate.) on determining subnet size.

You will also need to know the `databaseId` for your GitHub organization. The most common TAMU GitHub Organizations are listed below.

| GitHub Organization | Database ID |
| ------------------- | ----------- |
| `tamu-edu`          | `57198460`  |
| `tamu-edu-students` | `107003197` |

Follow the [GitHub instructions](https://docs.github.com/en/organizations/managing-organization-settings/configuring-private-networking-for-github-hosted-runners-in-your-organization#1-obtain-the-databaseid-for-your-organization) to obtain the database ID for your organization if it is not listed here.

GitHub [provides a script](https://docs.github.com/en/organizations/managing-organization-settings/configuring-private-networking-for-github-hosted-runners-in-your-organization#2-use-a-script-to-configure-your-azure-resources) to configure your VNet and the necessary Azure resources for this connection. Contact Cloud Services to run this script if you do not feel confident doing this yourself, or if you have any questions about the configuration.

#### Configure GitHub

Once your VNet is configured, contact the GitHub team to complete the setup work in the GitHub organization. Include the following information in your request:

- Your target subscription, VNet, and subnet names
- The GitHub repositories that should be granted access

#### Update GitHub Workflows

Once your GitHub repository has been configured for private subnet access, you will need to update your workflow YAML files to use the new runner group created by the GitHub team for your VNet.

```yaml
jobs:
  build:
    runs-on:
      group: <runner-group-name> # Provided by GitHub team
      labels: <standard runner labels, e.g. `ubuntu-latest`>
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Build and deploy
        run: |
          # Your build and deployment commands here
```

### Other CI/CD Platforms

If you are using a different CI/CD platform, such as Azure DevOps, Jenkins, or CircleCI, you can still connect to your VNet securely using a similar approach with a private endpoint. Consult the documentation for your platform or Cloud Services for assistance with configuring your VNet and CI/CD platform for this connectivity.

## Azure Bastion

For administrative access (RDP/SSH) to virtual machines in your spoke VNet, Cloud Services operates a shared Azure Bastion instance in the hub VNet. This is the approved method for administrative access to VMs and removes the need to assign public IPs to VMs or rely solely on the campus VPN.

Because spoke VNets are peered to the hub, the shared Bastion is automatically available to any VM in your spoke. When you open a VM in the Azure portal and select **Connect → Bastion**, the hub Bastion will appear as the connection option — no per-spoke Bastion deployment, `AzureBastionSubnet`, or additional peering configuration is required.

### Requirements

- The VM must be in a spoke VNet peered to the hub (the default for managed spokes).
- Your account must have at least `Reader` role on the VM, its NIC, and the hub Bastion resource. Contact Cloud Services if the Bastion option does not appear when attempting to connect.
- The VM's NSG must allow inbound RDP (3389) and/or SSH (22) from the hub `AzureBastionSubnet` range.
- VMs should not have public IP addresses assigned for administrative access.

### Connecting

1. Navigate to your VM in the Azure portal.
2. Select **Connect**, then choose the **Bastion** tab.
3. The shared hub Bastion will appear automatically.
4. Enter your VM credentials and select **Connect** to open a browser-based RDP/SSH session.

For native client (local RDP/SSH) access through Bastion tunneling, see [Connect using a native client](https://learn.microsoft.com/en-us/azure/bastion/connect-native-client-windows). The hub Bastion name and resource group can be obtained from Cloud Services.

### References

- [What is Azure Bastion?](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview)
- [Connect to a Windows VM using Bastion](https://learn.microsoft.com/en-us/azure/bastion/bastion-connect-vm-rdp-windows)
- [Connect to a Linux VM using Bastion](https://learn.microsoft.com/en-us/azure/bastion/bastion-connect-vm-ssh-linux)
- [Bastion and VNet peering](https://learn.microsoft.com/en-us/azure/bastion/vnet-peering)