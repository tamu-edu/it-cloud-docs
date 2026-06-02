# Deploying to a Private Subnet with GitHub Actions

For customers deploying to their TAMU Azure VNet directly from GitHub Workflow in their GitHub repository ("GitOps"), GitHub can join private subnets in the TAMU Azure environment to securely deploy build artifacts and still access dependencies from the internet through the shared firewall service. This allows GitHub to securely access external resources, such as package registries and other services, while keeping the GitHub instance itself isolated from direct internet access. The GitHub "Organization" and your target VNet will need one-time configuration for this with assistance from Cloud Services, and your workflow action yml(s) will need to be updated accordingly.

## Overview

This guide provides instructions for CI/CD deployment via GitHub private subnet into your TAMU Azure VNet for customers whose deployment pipeline comes directly from GitHub Workflow in their GitHub repository ("GitOps").

Consider the additional address space required for a dedicated GitHub subnet in your VNet design and plan accordingly. A minimum size of `/29` is required, which provides 6 usable IP addresses for GitHub runners. This should be sufficient for most use cases, but you may need to request a larger subnet if you have a high volume of builds or if you need to run multiple builds in parallel.

Note: While this is a no-cost option for GitHub deployment in TAMU Azure, it is not the only option. Alternatively, you can create an Azure Private Endpoint in your VNet (linked to a subnet) to connect privately to an Azure service. Your subscription will be charged for the Private Endpoint.


## Configure Your VNet for GitHub

To allow GitHub to join your environment's VNet, you will need to add a minimum-sized subnet dedicated to GitHub: Consider the additional address space required for a GitHub subnet in your VNet design and plan accordingly. A minimum of `/29` is required for GitHub, which provides 6 usable IP addresses for GitHub runners. <em>This is sufficient for most use cases</em>, but you may need a larger subnet if you have an unsually high volume of builds or if you need to run multiple builds in parallel. See [guide](https://docs.github.com/en/organizations/managing-organization-settings/configuring-private-networking-for-github-hosted-runners-in-your-organization#:~:text=To%20determine%20the%20appropriate%20subnet%20IP%20address%20range%2C%20we%20recommend%20adding%20a%2030%25%20buffer%20to%20the%20maximum%20job%20concurrency%20you%20anticipate.) on determining subnet size.

TODO: Provide vnet/subnet config...

## Configure GitHub for Private Subnet Access

TODO: Provide github config from customer perspective.

Once your VNet is configured, contact Cloud Services to have your GitHub instance configured for private subnet access. GitHub hosted runners will be granted specific access to your VNet (via dedicated GitHub subnet) and repository and will not have access to other repositories or other customers' VNets.

## Configure GitHub Workflow for Private Subnet Access

Once your Runner Group and Runner are created and authorized by Cloud Services, you must modify your GitHub Workflow YAML file to select them by `group` and `labels`:

```yaml
name: Your CI/CD Pipeline
...
jobs:
  deploy:
    runs-on:
      group: scraznet-private-customer--<name>
      labels: BasicLinuxRunnerForScraznetRunners
  ...
```

This tells GitHub to use the runners in the specified runner group for this workflow, which will ensure that your workflow has access to your private subnets and can deploy to your target VNet. Confirm connectivity and configuration by running a simple workflow, and work with Cloud Services to ensure that your runner group is correctly configured for your VNet and repository access if needed.
