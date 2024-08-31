# Migrating to Cloud

For many years, `github.tamu.edu` has been the primary location for hosting code repositories for Texas A&M University faculty, staff, and students. However, the service has become redundant with the cloud-hosted version of GitHub Enterprise (GitHub.com) and often lags in feature sets and security patches. Therefore, `github.tamu.edu` is now deprecated in favor of all projects being hosted on Github Enterprise Cloud in the `tamu-edu` and `tamu-edu-students` organizations.

A timeline for deprecation will be:

* Jun 2022:
    * A documentation website published with information on using GitHub Enterprise cloud and how to migrate to it.
    * An announcement of the deprecation of `github.tamu.edu` with links to documentation sent to the community
* Dec 2023:
    * No new repositories, organizations, or other resources will be allowed
    * Monitoring for recent access begins
* Jun 2024:
    * Appliance made read-only
    * SSH access is blocked
* Aug 30, 2024:
    * All data is archived and made read-only
* Sep 27, 2024:
    * Appliance is shut down 
* Sep 2025:
    * Appliance data is deleted

## Migration Options

There are two primary options for migrating your repositories from `github.tamu.edu` to GitHub Enterprise Cloud:

1. [**TAMU Migration Tool**](./migration_tool.md): The TAMU Migration Tool is a self-service tool that allows you to migrate your repositories from `github.tamu.edu` to GitHub Enterprise Cloud. This tool is best for repositories with multiple contributors and a large number of files. The TAMU Migration Tool will automatically migrate your repositories, including commit history, tags and branches, and most GitHub metadata like issues and pull requests, to the `tamu-edu` or `tamu-edu-students` organizations on GitHub Enterprise Cloud.

2. **Git Remote**: If you don't need issue, pull request, or comment metadata, you can use the Git Remote method to migrate your repositories. This method is best for repositories with a small number of files and contributors. The Git Remote method involves creating a new, empty repository in the `tamu-edu` or `tamu-edu-students` organizations on GitHub Enterprise Cloud and pushing your code to the new repository. Read more about [Pushing commits to a remote repository](https://docs.github.com/en/get-started/using-git/pushing-commits-to-a-remote-repository).
