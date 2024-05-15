# TAMU Migration Tool

The TAMU Migration Tool is a self-service tool that allows you to migrate your repositories from `github.tamu.edu` to GitHub Enterprise Cloud. This tool is best for repositories with multiple contributors and a large number of files. The TAMU Migration Tool will automatically migrate your repositories, including commit history, tags and branches, and most GitHub metadata like issues and pull requests, to the `tamu-edu` or `tamu-edu-students` organizations on GitHub Enterprise Cloud.

It is a serverless, event-driven application that uses AWS Lambda, S3, and DynamoDB to manage the migration process using GitHub's APIs.


## Prerequisites

- This tool only supports migrations from `github.tamu.edu` to GitHub Enterprise Cloud.
- You must have admin access to the repositories you want to migrate.
- You must have a GitHub account with access to the `tamu-edu` or `tamu-edu-students` organizations on GitHub Enterprise Cloud.

## Limitations

- While the TAMU Migration Tool is designed to migrate most of the data from your repositories, there are some limitations to be aware of. Read more about the type of data that will and will not be migrated in the [GitHub Enterprise Importer](https://docs.github.com/en/migrations/using-github-enterprise-importer/migrating-between-github-products/about-migrations-between-github-products) docs. 
- Users and Teams are not migrated. You will need to recreate these in the new organization. Migrated repositories will have the migration requestor as the only owner.
- Only organization-owned repositories are supported. You will need to transfer any personal repositories to an organization before migrating.

## Outline

To migrate your repositories using the TAMU Migration Tool, follow these steps:

1. Visit the [TAMU GitHub](https://github.cloud.tamu.edu) website and select *Migrate from GitHub Server* in the **Server** card.
2. Follow the checklist to ensure you have set up all the proper authentication and permissions. Click *Next* when all items are successful.
3. Choose the repositories you want to migrate, the destination organization (`tamu-edu` or `tamu-edu-students`) and click *Migrate*.

The tool will then begin the migration process for each repository you selected. You can monitor the progress of each migration in the tool's [status dashboard](https://github.cloud.tamu.edu/github/migration/status).

Once a migration is completed, the source repository on `github.tamu.edu` will be archived. The new repository on GitHub Enterprise Cloud will be named as the source organization and repository `<org>_<repo>` and will have the migration requestor as the only owner. The new repository will be private by default. A summary of the migration will be posted as an issue in the source repository.

