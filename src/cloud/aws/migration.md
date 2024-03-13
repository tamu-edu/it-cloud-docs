# Network Migration

On February 19th, 2024, a new network design was implemented for the TAMU AWS VPC. This new design is intended to further improve the default security posture of the AWS network configuration for the Aggie Innovation Platform (AIP). The new configuration will provide centralized firewall protection for AWS workloads, similar to how the campus network is protected by border and data center firewalls. 
  
Existing AWS accounts may or may not be impacted by this change depending on the resource types used. Any resource that uses a VPC network interface will be impacted. This includes, but is not limited to, EC2 instances, RDS instances, and Lambda functions.
 
Technology Services will be available to help all account owners migrate impacted resources, up to and including performing the migration.

For those that wish to migrate themselves, please refer to the [network specifications](./networking.md) for the new VPC design and details, and consult the guides below for specific resource types.

## Migration Guides

- <a href="#ec2-instances">EC2 Instances</a>
- <a href="#rds-databases">RDS Databases</a>
- <a href="#lambda">Lambda Functions</a>

## Common Prerequisites

Before migrating any resources, you should complete the following steps:

1. Determine which subnet or subnets you want to move the resource to and note the subnet ID(s).
   1. If your resource is using a public IP address, it will need to use a public subnet.
   2. If your resource is currently connecting to a campus service, it will need to use a campus subnet.
      1. Email [aip@tamu.edu](mailto:aip@tamu.edu) to request a consultation before getting access to a campus subnet. 
   3. All other resources should use a private subnet.
   4. More information on the network and subnets can be found [here](https://docs.cloud.tamu.edu/cloud/aws/networking.html#reference).
2. Copy any security groups in use by your resource to the new VPC.
   1. If you are only moving the resource to a new subnet within one of the TAMU shared VPCs, you can use the same security group.
   2. If you are having to move regions or VPCs, you will need to copy the security groups. See [copying security groups](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/working-with-security-groups.html#copy-security-group) for instructions.
   3. Note the new security group ID for use in the migration process.

### EC2 Instances

It's not possible to move an existing instance to another subnet, Availability Zone, or VPC. Instead, you can create a new Amazon Machine Image (AMI) from the source instance to manually migrate the instance. Next, use the new AMI to launch a new instance in the desired subnet, Availability Zone, or VPC. And finally, reassign any Elastic IP addresses from the source instance to the new instance. Note that if you need to migrate to a supported region, Elastic IP addresses are not portable across regions and will change.

There are two methods to migrate the instance:

- Use the AWS Systems Manager automation document [`AWSSupport-CopyEC2Instance`](https://docs.aws.amazon.com/systems-manager-automation-runbooks/latest/userguide/automation-awssupport-copyec2instance.html).
- Manually create an instance image and launch a new instance from the image. 

We recommend using the AWS Systems Manager automation document to copy the instance. This method is faster and less error-prone than manually copying the instance. Please be sure to complete the common prerequisites before using the automation document. You will need to have the following information available:
- The instance ID of the source instance.
- The subnet ID of the destination subnet.
- The security group ID of the destination security group.

Once the automation document has been run, you will need to:
- manually reassign any Elastic IP addresses from the source instance to the new instance, if applicable.
- reassign any EC2 instance roles, if applicable.
- clean up (delete/terminate) the source instance and any associated resources.
- update any DNS records or other references to the source instance.


### RDS Databases

The process for migrating an RDS database depends on whether you are migrating within the same region or to a different region. To move to another set of subnets, Availability Zones, or VPC within the same region, you can simply modify the RDS instance. To move to a different region, you can create a snapshot of the RDS instance and restore it in the new region.

```admonish info
Details for migrating RDS in the same region: [Migrate an Amazon RDS DB instance to another VPC](https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/migrate-an-amazon-rds-db-instance-to-another-vpc-or-account.html).
```

```admonish info
Details for migrating RDS to a different region: [Migrate Amazon Aurora and Amazon RDS to a new AWS region](https://aws.amazon.com/blogs/database/migrate-amazon-aurora-and-amazon-rds-to-a-new-aws-region/).
```


### Redshift Clusters

To move a Redshift cluster to a different subnet group, you can modify the cluster to use the new subnet group. If you need to move to a different VPC, you can create a snapshot of the cluster and restore it in the new VPC.

```admonish info
Details for migrating Redshift: 
- [Migrate Amazon Redshift to a new subnet group](https://docs.aws.amazon.com/redshift/latest/mgmt/managing-cluster-subnet-group-console.html)
- [Migrate Amazon Redshift to a new VPC](https://repost.aws/knowledge-center/move-redshift-cluster-vpcs)
