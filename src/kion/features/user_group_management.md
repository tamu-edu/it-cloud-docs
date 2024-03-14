# Getting Started With Kion

## User Group Management

To manage user groups, click on the User Groups tab in the left-hand navigation bar.
To create a new user group, click the "Create User Group" button in the top right corner of the User Groups page.

```admonish collapsible=true class="aggiecustom2" title="User Groups"
![User Groups](./img/group_management.png)
```

```admonish note
Please refer to [Best Practices](./best_practices.md) for more information on appropriate naming schemes for user groups.
```


```admonish collapsible=true class="aggiecustom2" title="User Groups"
![Create User Group](./img/user_group_creation.png)
```

To add users to a user group, click on the user group you want to add users to, and then click the "Add Users" button in the top right corner of the User Group page.

```admonish warning
Users who are not already in Kion will need to log in to Kion at [kion.cloud.tamu.edu](https://kion.cloud.tamu.edu) before they can be added to a user group.
```

## Adding User Groups to Projects

Once a group has been created, it can be added to a project you own by navigating to the users tab of the project and clicking the 'Manage User Permissions' button. From there, you can add the user group to the project and assign the appropriate permissions.

```admonish collapsible=true class="aggiecustom2" title="Project User Permissions"
![Manage User Permissions](./img/manage_user_permissions.png)
```

```admonish collapsible=true class="aggiecustom2" title="Project User Permissions"
![Add User Group](./img/add_user_groups_to_project.png)
```

```admonish warning
Be careful when assigning Owner permissions to a user group. This will give all users in the group full control over the project. For most cases, it is recommended to assign a group you create to the User role, which allows access but not the ability to change Project parameters. By default, the Owner role is reserved for the Project/account requesters and the Kion Platform administrators.
```

## Configuring Cloud Access Roles for User Groups

To create or configure Cloud Access Roles for user groups, click on the Cloud Management tab in the Project Bar. From there, select the Cloud Access Roles tab, and click the 'Add' button to create a new role.

```admonish collapsible=true class="aggiecustom2" title="Add Cloud Access Roles"
![Cloud Access Roles](./img/add_cars.png)
```

To assign a user group to a Cloud Access Role, click on the role you want to assign the user group to, and then click the 'Add User Group' button in the top right corner of the Cloud Access Role page.

```admonish collapsible=true class="aggiecustom2" title="Cloud Access Role Details"
![Add User Group to Role](./img/add_cars_details.png)
```

Then, on the next page, configure the IAM permissions for that user group (AWS IAM Policies, Azure Role Definitions, etc.)

```admonish collapsible=true class="aggiecustom2" title="Cloud Access Role Details"
![Add User Group to Role](./img/add_cars_details_2.png)
```

```admonish note
Please refer to [Best Practices](./best_practices.md) for more information on appropriate permissions for user group Cloud Access Roles.
```

Finally, click 'create'. You should be able to see that Cloud Access Role in the list of Cloud Access Roles for the project, and it will grant the users in the assigned group the ability to federate into the specified accounts in your project with the specified permissions.