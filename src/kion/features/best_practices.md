# Getting Started With Kion

## User Management

1. Don't attempt to create users in Kion. Users are created automatically when they log in for the first time.

2. When creating User Groups, use the following naming convention: `<project>-<role>`. For example, for the project `dit-cscn-aip-test-001`, if you're creating a user-group for users, you would name it or `dit-cscn-aip-test-001-users`.

2. Don't create Cloud Access Roles granting Administrator access to users. This is not necessary and can lead to security vulnerabilities; practice the principle of least privilege.
    - As a default, only the user(s) who ***own*** the project have full administrative access to the accounts in a project.


