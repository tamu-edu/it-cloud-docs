# Accessing Kion

There are two sets of permissions that control access to Kion: project permissions and cloud access roles. Project permissions control access to Kion itself, while cloud access roles control access to cloud accounts.

## Project Access

Project permissions control access to Kion itself. There are two main roles in Kion: Project Owner and Project User. Each role has different permissions in Kion. 

A project user can view all information about a project, such as financial and compliance data, but cannot make changes to the project. A project owner can view and edit most information about a project, including adding and removing users, requesting exemptions, creating cloud access roles, and managing project settings.

For more information on project permissions, see the [Project Permissions](https://support.kion.io/hc/en-us/articles/360035054871-Managing-User-Permissions-on-a-Project) article.

## Cloud Account Access

Kion grants access to cloud accounts using [Cloud Access Roles](https://support.kion.io/hc/en-us/articles/360021623272-What-is-a-Cloud-Access-Role), which represent a set of permissions (IAM policies or role definitions) that allow a user to perform specific actions in a cloud account.

A Cloud Access Role has three main components:
- Access Type
- Users or Groups assigned
- Permission


### Access Types

For all cloud providers, Kion supports automatic login to the provider's web console using a trust federation. You only need to sign in once to Kion, and then you can access your cloud accounts without having to sign in again.

For AWS, Kion also supports [short-term access](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_use-resources.html) and long-term access keys. These keys can be used with the AWS CLI, SDKs, and other automation tools. Short-term access keys are valid for four hours, and long-term access keys are valid for 90 days or until they are rotated. Read more about [AWS Access Keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/security-creds.html), including best practices and security warnings.

A cloud access role can allow one or more of these access types. For example, a non-admin role might allow web access and short-term access, but not long-term access.


### User and Group Assignments

A cloud access role can be assigned to one or more users and groups. When a user is assigned a role, either directly or through a group, they can access cloud accounts in the project with the permissions granted by the role. Project owners can assign roles to users and groups, and users can request access to roles.

To assign a role to a user, that user must have logged into Kion at least once to create their account in Kion's database. 

Project owners can also create groups to use for role assignments. This makes it easier to manage access for a large number of users and projects. A user must have logged into Kion at least once to be added to a group, too.


### Permissions

The permissions granted by a cloud access role are defined by IAM policies for AWS and Azure roles for Azure. These policies define what actions a user can perform and what resources they can perform those actions on.

Cloud Access Roles are intended to be cloud-agnostic and can be used across multiple cloud providers. When creating roles to assign to humans, it is common to make these roles relate to specific job functions, like Database or Server Administrators, then use the cloud-specific policies and roles to grant the necessary permissions.

When creating roles to assign to applications or services, it is common to make these roles relate to specific tasks, like reading from a specific S3 bucket or writing to a specific database.


#### AWS IAM Policies

AWS provides hundreds of pre-written policies that make it convenient for you to assign appropriate permissions to users, groups, and roles. It is faster than writing the policies yourself and includes permissions for many common use cases.

The AWS-managed policies are already imported into Kion and can be assigned to a cloud access role. These policies are updated by AWS, so you don't have to worry about keeping them up to date.


##### Customer Managed Policies

If you need to grant a set of permissions that isn't covered by the AWS-managed policies, you can create your own customer-managed policy. These policies are created in your AWS account, imported into Kion, and then assigned to a cloud access role. An example policy might be to grant access to a specific S3 bucket or to allow a user to create and manage EC2 instances.


```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "1",
    "Effect": "Allow",
    "Action": "s3:*",
    "Resource": [
      "arn:aws:s3:::mybucket",
      "arn:aws:s3:::mybucket/*"
    ]
  }]
}
```

When you create IAM policies, follow the standard security advice of granting least privilege, or granting only the permissions required to perform a task. Determine what users and roles need to do and then craft policies that allow them to perform only those tasks.

Learn more about [AWS Policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html).

#### Azure Roles
 
Azure uses role-based access control (RBAC) to manage access to resources. An Azure role is a collection of permissions that can be assigned to a particular scope or resource.

Like AWS, Azure provides a [set of pre-written roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles) that you can use to manage access to your resources. These roles are already imported into Kion and can be assigned to a cloud access role.


##### Custom Roles

If you need to grant a set of permissions that isn't covered by the built-in roles, a custom role definition can be created. These roles will need to be created by an Azure or Kion administrator. Please contact aip@tamu.edu to request a custom role definition.