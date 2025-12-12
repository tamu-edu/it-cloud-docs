# Amazon Web Services (AWS)

AWS is the largest cloud provider in the world and offers a wide range of services to meet the needs of any organization. The TAMU Cloud Services provides a secure and compliant environment for TAMU customers to use AWS services.

## Requesting an AWS Account

To learn about and request an AWS account, please visit the [Public Cloud Accounts](https://www.it.tamu.edu/services/services-by-category/it-professional-services/cloud-public.html) resource.

## Accessing AWS

### Using the web console

The AWS Management Console is a web-based interface for accessing and managing AWS services. You can sign in to the console at [https://console.aws.amazon.com/](https://console.aws.amazon.com/) using your NetID.

```admonish info class="aggiecustom2" title="Access AWS"
[https://console.aws.amazon.com/](https://console.aws.amazon.com/)
```

### Using the AWS CLI

The AWS Command Line Interface (CLI) is a unified tool to manage your AWS services. With just one tool to download and configure, you can control multiple AWS services from the command line and automate them through scripts. The AWS CLI is available for Windows, Mac, and Linux. More information at [AWS CLI](https://aws.amazon.com/cli/).

To set up your AWS CLI automatically, we recommend using our [`aiphelper`](https://github.com/tamu-edu/aiphelper) tool. This tool will configure your AWS CLI with the correct settings and is especially useful for users who need to access multiple AWS accounts.

To configure the AWS CLI manually, you will need to add the following to your `~/.aws/config` file for each AWS account you want to access:

```ini
[profile {profileName}]
sso_start_url = https://aggie-innovation-platform.awsapps.com/start
sso_region = us-east-2
sso_account_id = {accountId}
sso_role_name = {roleName}
region = us-east-1
output = json
```

Replace `{profileName}` with the name of your profile, which can be anything you want to name it, `{accountId}` with your AWS account ID, and `{roleName}` with the name of the role you want to assume, typically `AdministratorAccess`.

Once you have created profiles, either with `aiphelper` or manually, you can use the following command to log in to AWS:

```bash
aws sso login --profile {profileName}
```

#### Granted

If you often work with AWS from the CLI, we recommend using a third-party CLI tool [`granted`](https://www.granted.dev/) to help speed up your workflow. This tool allows you to easily switch between AWS accounts and roles, and provides a number of other useful features.

## Collaboration and Access Control

We use Microsoft Entra ID for SSO access to AWS and create an Entra ID group to grant Admin access for each account. If you are an account owner, and wish to grant access to other users, please use the [Microsoft My Groups portal](https://myaccount.microsoft.com/groups) to add users to the appropriate group. If you want to grant another role than Admin, please contact the Cloud Services team for assistance.

