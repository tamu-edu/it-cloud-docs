# Cloud Management

The Cloud Management features in Kion provide centralized control over your cloud resources, policies, and access configurations. These tools help you maintain security standards, streamline resource provisioning, and ensure consistent governance across all your cloud accounts. This section covers the key cloud management capabilities available to project owners and how they support your cloud operations.

## Overview

The Cloud Management tab in Kion gives you visibility into and control over the cloud-specific configurations applied to your projects and accounts. From this central location, you can view and manage:

- **Cloud Access Roles** - Permission sets that control who can access your cloud accounts and what they can do
- **Cloud Rules** - Collections of policies, configurations, and resources that are automatically applied to cloud accounts
- **Compliance Standards** - Security and compliance checks that monitor your cloud resources
- **Cloud Policies** - Individual policies that define permissions and access controls


## Cloud Access Roles

Cloud Access Roles (CARs) are one of the most important tools for managing access to your cloud accounts. A Cloud Access Role is a named set of permissions that can be assigned to users or groups, allowing them to perform specific actions in your cloud accounts.

### Why Use Cloud Access Roles?

Rather than granting individual permissions to each user, Cloud Access Roles provide a standardized, reusable way to manage access. This approach:

- **Reduces complexity** - Define permissions once and assign them to multiple users
- **Improves security** - Consistently apply the principle of least privilege
- **Simplifies management** - Update permissions in one place instead of for each user
- **Enables self-service** - Users can request access to predefined roles

### Common Cloud Access Role Patterns

Most organizations create Cloud Access Roles based on job functions or specific tasks:

**Job Function Roles:**
- Database Administrator - Access to manage database services
- Network Administrator - Access to configure networking resources
- Developer - Access to deploy applications and view logs
- Read-Only Auditor - View-only access for compliance and auditing

**Task-Based Roles:**
- S3 Bucket Reader - Read access to specific S3 buckets
- EC2 Instance Manager - Ability to start, stop, and manage EC2 instances
- Cost Reporter - Access to view billing and cost information

### Managing Cloud Access Roles

As a project owner, you can assign existing Cloud Access Roles to users and groups within your projects. To assign a Cloud Access Role:

1. Navigate to your project and select the **Cloud Management** tab
2. View the available Cloud Access Roles
3. Assign roles to users or groups through the project's **Users** tab

For detailed instructions on working with Cloud Access Roles, see [Cloud Access Roles](./access_roles.md).

```admonish info
Users must have logged into Kion at least once before they can be assigned Cloud Access Roles or added to groups.
```


## Cloud Rules

Cloud Rules are powerful automation tools that ensure your cloud accounts are configured consistently and securely from the moment they are created. A Cloud Rule is a collection of cloud-specific resources, policies, and configurations that can be automatically applied to cloud accounts within a project.

### What Cloud Rules Can Do

Cloud Rules can automate many aspects of account configuration, including:

- **Security configurations** - Automatically enable logging, monitoring, and security services
- **Networking setup** - Configure VPCs, subnets, and network security groups
- **Compliance policies** - Apply required security standards and compliance checks
- **Resource tagging** - Ensure resources are tagged according to organizational standards
- **Service quotas** - Set limits on resource usage to prevent cost overruns
- **Access policies** - Define who can access resources and under what conditions

### How Cloud Rules Work

When a Cloud Rule is associated with a project, it is automatically applied to all accounts within that project. This ensures that:

- New accounts start with the correct security and compliance configurations
- Accounts remain compliant as organizational policies change
- Security best practices are consistently enforced
- Manual configuration errors are eliminated

### Viewing Applied Cloud Rules

To see which Cloud Rules are applied to your project:

1. Navigate to your project
2. Select the **Cloud Management** tab
3. Review the list of Cloud Rules associated with your project

```admonish note
Cloud Rules are typically managed by your organization's cloud administrators or security team. If you need a new Cloud Rule or changes to existing rules, contact your cloud governance team or submit a request through aip@tamu.edu.
```


## Compliance Standards

Kion continuously monitors your cloud resources against industry security standards and organizational policies. The compliance features help you:

- **Identify security gaps** - Discover misconfigurations and potential vulnerabilities
- **Track compliance posture** - Monitor adherence to standards like CIS Benchmarks
- **Generate reports** - Produce compliance documentation for audits
- **Remediate issues** - Get specific guidance on fixing compliance findings

For detailed information on compliance features, see [Compliance](./compliance.md).


## Resource Management

The Cloud Management features also provide visibility into your cloud resources across all accounts in a project. This includes:

### Resource Inventory

View all resources deployed in your cloud accounts, including:
- Virtual machines and compute instances
- Storage buckets and volumes
- Databases and data services
- Networking components
- Application services

### Reserved Instances and Savings Plans

Track and manage cost-saving commitments such as:
- AWS Reserved Instances
- Azure Reserved VM Instances
- GCP Committed Use Discounts
- Savings Plans and other discount programs

This information helps you optimize costs by understanding your current commitments and identifying opportunities for additional savings.


## Best Practices for Cloud Management

To get the most value from Kion's cloud management features:

1. **Review regularly** - Periodically check the Cloud Management tab to understand what policies and rules are applied to your projects

2. **Use groups for access** - Create user groups and assign Cloud Access Roles to groups rather than individual users. This simplifies management as your team grows.

3. **Request the minimum access needed** - Follow the principle of least privilege by requesting only the Cloud Access Roles your users actually need

4. **Understand applied rules** - Familiarize yourself with the Cloud Rules applied to your project so you understand what is being automatically configured

5. **Monitor compliance** - Regularly review compliance findings and work with your security team to remediate issues

6. **Document custom configurations** - If you create custom Cloud Access Roles or request special configurations, document why they were created and who uses them


## Getting Help

The Cloud Management features in Kion are powerful but can be complex. If you need assistance:

- **Kion Documentation** - Visit the [Kion Customer Success Center](https://support.kion.io/) for detailed documentation
- **Technology Services Support** - Contact aip@tamu.edu for help with TAMU-specific configurations
- **Your Organization's Cloud Team** - Reach out to your cloud governance or security team for guidance on policies and standards

For more information on other Kion features, explore the following topics:
- [Getting Started with Kion](./getting_started.md)
- [Cloud Access Roles](./access_roles.md)
- [Budgets and Finances](./finances.md)
- [Compliance](./compliance.md)
