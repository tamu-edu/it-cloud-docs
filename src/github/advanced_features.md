# Advanced Features

GitHub Enterprise includes some features that have metered billing or are a paid add-on feature.

## Free Features

A free tier for the consumption features is being made available to all repositories. Usage beyond the free tier is currently disabled, but will be enabled in the future and will require billing information.

### Packages

[GitHub Packages](https://github.com/features/packages) is a platform for hosting and managing packages, including containers and other dependencies, and will be made available to all teams and organizations with free allocations outlined below.

| Product | Free tier |
| ------- | --------- |
| Storage | 5 GB |
| Data transfer out | 15 GB |
| Actions minutes [^1] | 1,000 min |

> Rates subject to change. See [About Billing for GitHub Packages](https://docs.github.com/en/billing/managing-billing-for-github-packages/about-billing-for-github-packages) for the latest information and rates.<br/>

[^1]: The free tier of actions minutes uses a shared pool of compute; performance and availability is not guaranteed. For guaranteed performance and availability, consider using a self-hosted runner pool.


### Actions

[GitHub Actions](https://docs.github.com/en/actions) is a continuous integration and continuous delivery (CI/CD) platform that allows you to automate your build, test, and deployment pipeline. The environment in which these workflows execute is called a runner, and can be [GitHub-hosted](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners) or [self-hosted](https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners).

The institutional and student organizations have a pool of GitHub Actions minutes to use to run their project's jobs. There is no limit to the number of runner minutes that can be consumed, but there is a limit to the number of minutes that can be used in a month before billing information is required.

Data transfer out from Packages to Actions is free, but action consumes Packages storage when storing artifacts.

### Large File Storage (LFS)

[Large File Storage (LFS)](https://git-lfs.github.com/) is a file storage service that allows you to store large files in your GitHub repository. LFS is enabled in the Institution organization, but disabled in the student organization. The free tier of LFS for institutional repositories is 1GB of storage and 1GB of transfer. The cost for additional usage will be made available in the future and will require billing information.

| Product | Free |
| ------- | --------- |
| LFS Storage | 1GB |
| LFS Data transfer out | 1GB |

However, for both organizations, we strongly encourage the use of [git-annex](https://git-annex.branchable.com/) over git-lfs, with Microsoft OneDrive or Google Drive as the storage backend.

## Metered Features

### Packages

GitHub packages usage consumes storage and data transfer, and usage beyond the free tier will require billing information. Student organization repositories that need to exceed the free tier should relocate their repository to the institutional organization with a faculty or staff sponsor to facilitate a billing agreement.


### Codespaces

[Codespaces](https://docs.github.com/en/codespaces) are hosted, configurable development environments for GitHub repositories. Codespaces can be enabled for a repository and/or a specific GitHub user. There is no free tier for codespaces, and billing information will be required for usage.

Codespaces usage is billed according to the units of measure in the following table:

| Product | SKU | Unit of measure | Price |
| ------- | --- | --------------- | ----- |
| Codespaces Compute | 2 core  | 1 hour | $0.18
|                    | 4 core  | 1 hour | $0.36
|                    | 8 core  | 1 hour | $0.72
|                    | 16 core | 1 hour | $1.44
|                    | 32 core | 1 hour | $2.88
| Codespaces Storage | Storage | 1 GB-month| $0.07

> Rates subject to change. See [About Billing for Codespaces](https://docs.github.com/en/billing/managing-billing-for-github-codespaces/about-billing-for-codespaces) for the latest information and rates.

To enable Codespaces, please [contact us](/contact_us).


## Add-on Features

### Actions Runner Pools

If your project requires a specialized virtual environment, such as a different operating system or CPU platform, a private runner pool can be created. You can use your own infrastructure to add a [self-hosted runner](https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners) to a single repository that you own; or, AIP can host a runner pool for you to use to run jobs for multiple repositories that you own.

To get started setting up a self-hosted runner, follow the [self-hosted runners guide](https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners), or [contact us](/contact_us) to host them for you.


### GitHub Advanced Security

[GitHub Advanced Security](https://docs.github.com/en/get-started/learning-about-github/about-github-advanced-security) is a paid add-on feature that enabled additional security features, such as code and secret scanning. It is free for public repositories, and is available to purchase for use in internal and private repositories.

Billing for GitHub Advanced Security is on a 90-day rolling count of unique committers to a repository with Advanced Security enabled. A committer is only ever counted once, even if they commit to multiple repositories. Billing is done on an annual basis based on a forecast of unique committers, but can be adjusted as needed at any time.

See [About billing for GitHub Advanced Security](https://docs.github.com/en/enterprise-cloud@latest/billing/managing-billing-for-github-advanced-security/about-billing-for-github-advanced-security) for more information.

To purchase GitHub Advanced Security, please [contact us](/contact_us).


### Repository Templates

Repository templates allow you to have a team automatically assigned to all new repositories in the tamu-edu organization that match a given prefix. This can be useful for setting up a team with the appropriate permissions for a new project, or for automatically adding a specific set of collaborators to a repository. To make a new repository template, add a pull request to the [org-settings](https://github.com/tamu-edu/org-settings/tree/main/repo_settings) repository, following the directions in the README.md file. The code for the app behind this feature can be found at [tamu-edu/it-ae-github-app-org-repo-settings](https://github.com/tamu-edu/it-ae-github-app-org-repo-settings).