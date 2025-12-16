# Getting Started With Kion

Once a Cloud Service Provider account has been [requested and approved](https://it.tamu.edu/cloud/get-started/index.php), users may log into Kion at [kion.cloud.tamu.edu](https://kion.cloud.tamu.edu) by clicking the Microsoft Entra ID button and authenticating with their NetID. 

The first thing you will see when you log into Kion is a dashboard. From here, you can access your cloud accounts, monitor budgets, and verify compliance posture. 

## Access your Cloud Accounts

The most common use for Kion is to access your cloud accounts. You will have one or more [Cloud Access Roles](./features/access_roles.md) assigned to each cloud account. These roles allow you to access the cloud account with various levels of permissions. It is best practice to always use the least-privileged role that allows you to perform the necessary actions.

You can access your accounts from many places in Kion, including the dashboard, the projects page, and the accounts page. Look for dropdown menus with a cloud icon to select the account and role you want to access.

<p align="center">
  <img src="./img/cloud_access_box_large.png" height="50" />
  <img src="./img/cloud_access_box_min.png" height="50" />
</p>

Depending on the type of cloud account, different types of access are available. All cloud accounts will have a *Web Access* type which will take you to the web console for that provider, while AWS, for instance, will also have *Short-Term Access* and *Long-Term Access Key* types for use with the CLI, code, or other automation tools. 


## Navigation

Once logged into Kion, you will be presented with a dashboard and a sidebar menu with the following tabs:

- **OU** - This tab shows how your projects are organized. It will show how any rules and policies are inherited, and how budgets are allocated.
- **Projects** - This tab lists all projects you have access to and an overview of their spending status. This will likely be the tab you use most often.
- **Users** - This tab lists the users and groups in Kion. If you are a project owner, you can create new groups and add users to them here to use later in your projects.
- **Cloud Management** - This tab allows you to find more information about the Cloud Rules, Policies, and Roles that are available to you to use in your projects.
- **Requests** - This tab shows you the status of any requests that you have made, or from others involving the projects that you own.
- **Settings** - This tab allows you to change settings for your account, such as your dashboard layout, default regions, and linked accounts.


## Projects

In Kion, a Project is a collection of accounts that are managed together. In most cases, you will only have one account in a project. However, you may have multiple accounts in a project if you are managing a large number of accounts. 

When you select a project, you will have several options at the top of the page to select from which give you the capability to access your cloud accounts, monitor budgets, and verify compliance posture.

![Kion Project Options](./img/kion_project_details.png)

- **Accounts** - This tab lists all of the accounts that are in the project, and allows you to access them.
- **Financials** - This tab shows you the budget and spending status for the project. You can manage your budgets and generate reports and graphs. 
- **Savings Opportunities** - This tab shows you ways to save money on your cloud spending. It will show you recommendations for Reserved Instances and other cost-saving opportunities.
- **Enforcements** - This tab shows you and enforcements that are in place for the project. Enforcements are alerts or actions triggered by spending conditions, such as a budget being exceeded.
- **Cloud Management** - This tab allows you to find more information about the Cloud Rules, [Cloud Access Roles](./features/access_roles.md), and related resources that are applied to the project.
- **Compliance** - This tab shows you the compliance posture of the project. It will show you any findings that are present, and give you recommendations on how to fix or suppress them.
- **Users** - This tab shows you the users and groups that have access to the project. This access is separate from any Cloud Access Roles that are assigned to the accounts in the project.
- **Permissions** - This tab shows you the permissions that users and groups have to the project, based on the settings in the Users tab.
- **Notes** - This tab shows any notes that have been added to the project. This section is currently not able to be edited but will be in the future.
- **Settings** - This tab allows you to change notification settings for the project.

> [!NOTE]
> Detailed descriptions for each of these tabs are available in [Kion's Customer Success Center](https://support.kion.io/hc/en-us/articles/360057133931-Project-Details).
