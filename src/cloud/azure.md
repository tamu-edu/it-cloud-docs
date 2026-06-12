# Microsoft Azure (Azure)

Azure is a leading cloud provider in the world and offers a wide range of services to meet the needs of any organization. The TAMU Cloud Services provides a secure and compliant environment for TAMU customers to use Azure services.

* [Secure Azure Network Design](./azure/network/network.md)
* [Creating Subnets](./azure/network/creating_subnets.md)
* [Understanding Policy Enforcement](./azure/network/policy_effects.md)

## Requesting an Azure Account

To learn about and request an Azure account, please visit the [Public Cloud Accounts](https://www.it.tamu.edu/services/services-by-category/it-professional-services/cloud-public.html) resource.

## Accessing Azure

### Using the web console

The Azure Management Console is a web-based interface for accessing and managing Azure services. You can sign in to the console at [https://portal.azure.com/](https://portal.azure.com/) using your NetID.

> [!NOTE]
> **Access Azure**
>
> [https://portal.azure.com/](https://portal.azure.com/)

### Using the Azure CLI

The Azure Command Line Interface (CLI) is a unified tool to manage your Azure services. With just one tool to download and configure, you can control multiple Azure services from the command line and automate them through scripts. The Azure CLI is available for Windows, Mac, and Linux. More information at [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/).

Issue `az login` to log in to Azure and follow the prompts to authenticate with your NetID and select from among your authorized subscriptions.

# TODO: Nothing below this bar is reviewed yet.
---------

TODO: Review aws docs here on aiphelper and azure with aiphelper.

~To set up your Azure CLI automatically, we recommend using our [`aiphelper`](https://github.com/tamu-edu/aiphelper) tool. This tool will configure your Azure CLI with the correct settings and is especially useful for users who need to access multiple Azure accounts.~

## Collaboration and Access Control

We use Microsoft Entra ID for SSO access to Azure and create an Entra ID group to grant Admin access for each account. If you are an account owner, and wish to grant access to other users, please use the [Microsoft My Groups portal](https://myaccount.microsoft.com/groups) to add users to the appropriate group. If you want to grant a role other than Admin, please contact the Cloud Services team for assistance.
