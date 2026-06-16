# Azure Services Configuration

In this section, you will find documentation on how to configure and deploy specific Azure services in a way that is compatible with the TAMU-managed network design and meets the requirements outlined in the [Network Design](design.md) page.

A pre-requisite for deploying resources to the TAMU-managed network in Azure is understanding the network design and creating the necessary subnets in your spoke VNets. See the [Network Design](design.md) and [Creating Subnets](creating_subnets.md) pages.

## Scope

### In-Scope Services

A service is generally required to be connected to the TAMU-managed network if it is a workload-hosting, compute, or application-facing Azure service that either:

- Is accessible from the public internet,
- Can initiate outbound network connections,
- Runs customer-controlled code, scripts, containers, or jobs,
- Provides interactive access to an execution environment, or
- Is deployed into, or integrated with, a customer-managed virtual network.

The following is a non-exhaustive list of common Azure services that are in scope for this network policy:

| Service | Documentation |
| --- | --- |
| [Azure Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/) | [Connect a VM to the TAMU network](services/connect_vm.md) ([PR59](https://github.com/tamu-edu/it-cloud-docs/pull/59)) |
| [Azure Load Balancers (public)](https://learn.microsoft.com/en-us/azure/load-balancer/) | [Connect a public load balancer to the TAMU network](services/connect_public_lb.md) ([PR66](https://github.com/tamu-edu/it-cloud-docs/pull/66)) |
| [Azure Application Gateways](https://learn.microsoft.com/en-us/azure/application-gateway/) | [Connect App Gateway to the TAMU network](services/connect_app_gateway.md) ([PR67](https://github.com/tamu-edu/it-cloud-docs/pull/67)) |
| [Bastion Hosts](https://learn.microsoft.com/en-us/azure/bastion/) | |
| [Azure API Management](https://learn.microsoft.com/en-us/azure/api-management/) | |
| [Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/) | [Connect AKS to the TAMU network](services/connect_aks.md) |
| [Azure App Service](https://learn.microsoft.com/en-us/azure/app-service/) | [Connect App Service to the TAMU network](services/connect_app_service.md) |
| [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/) | [Connect Functions to the TAMU network](services/connect_azure_functions.md) ([PR68](https://github.com/tamu-edu/it-cloud-docs/pull/68)) |
| [Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/) | [Connect Container App to the TAMU network](services/connect_container_app.md) |
| [Azure Container Instances](https://learn.microsoft.com/en-us/azure/container-instances/) | [Connect Container Instances to the TAMU network](services/connect_container_instances.md) |
| [Azure Batch](https://learn.microsoft.com/en-us/azure/batch/) | |
| [Azure Spring Apps](https://learn.microsoft.com/en-us/azure/spring-apps/) | |
| [Azure Service Fabric](https://learn.microsoft.com/en-us/azure/service-fabric/) | |

> [!TIP]
> Missing connection docs for your service? Contact the Cloud Services team to request documentation for connecting your service to the TAMU-managed network. Or, if you have already figured it out, contribute your documentation and share it with the team!

### Out-of-Scope Services

Some Azure services may not be directly subject to this policy if they do not host customer code, do not expose a workload endpoint, and do not initiate customer-controlled network traffic. However, they may still require review if they need to be publicly accessible or connect to in-scope workloads.

Examples that may require separate evaluation include:

- Storage accounts
- Key Vaults
- Azure SQL Database
- Cosmos DB
- Event Hubs
- Service Bus
- Log Analytics workspaces
- Managed identity and Azure control-plane services
- Azure DevOps and GitHub-hosted agents
- Azure AI services (e.g., Azure OpenAI, Cognitive Services)
- Azure Data Factory and Synapse Analytics
- Azure Logic Apps and Power Automate
- Azure Monitor and Application Insights

Always evaluate the specific requirements and risks of each service in the context of your overall architecture and security posture, and consult with the Cloud Services team if you have any questions about whether a particular service is in scope or how to configure it appropriately.
