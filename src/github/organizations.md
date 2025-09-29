# Organizations and Teams

Texas A&M University Enterprise GitHub has two organizations: one for [faculty, staff, and research projects](https://github.com/tamu-edu){target=_blank}, and one for [instruction and students](https://github.com/tamu-edu-students){target=_blank}.
We have limited organizations to two for various technical and administrative reasons. Using two large organizations allows for easier collaboration and simpler administration; however, it also introduces technical challenges sharing with many members. Our goal is to make as many GitHub Organization features as possible available to members.

## Institutional Org

[`tamu-edu`](https://github.com/tamu-edu){target=_blank} is the organization for faculty and staff. Use this organization for things like business applications, websites, research, and other projects that do not involve academic or instructional activities.

## Student Org

[`tamu-edu-students`](https://github.com/tamu-edu-students){target=_blank} is the organization for instructional, academic, and student use. Use this organization for things like course material, class projects, assignments, and other academic or instructional projects.


---

## Features Overview

Our goal is to make as many GitHub Organization features as possible available to members. Some features have [limitations](#limitations).

### Single Sign-on

Texas A&M University Enterprise GitHub is connected to the Texas A&M University directory via Microsoft Azure Active Directory (Azure AD) for single-sign-on to enforce the use of NetID credentials and two-factor authentication to access resources in the organizations.

### Membership

Membership in an organization is managed by Azure AD using automated provisioning and de-provisioning (SCIM). Organization administrators should only modify membership in Azure AD. Users entitled to self-join can use the [Texas A&M GitHub website](https://github.cloud.tamu.edu).

Team membership is also managed and synchronized from the Texas A&M University directory. Please see the [Teams](teams.md) page for more details.

### Outside Collaborators

Outside collaborators are allowed in both organizations. You can invite outside collaborators to join the organization by email or GitHub username. Outside collaborators must have [two-factor authentication](https://docs.github.com/en/enterprise-cloud@latest/authentication/securing-your-account-with-two-factor-authentication-2fa){target=_blank} enabled in their personal GitHub account to access a Texas A&M University Enterprise GitHub organization.

### Projects

Any organization member can create an organization-wide project or project board and invite other organization members or teams to collaborate on it. By default, organization-wide projects are private and only visible to people with read, write, or admin permissions to the project. Only create an organization-wide project for projects that span multiple repositories; a repository owner should create a project or project board in a repository for all others.


---

## Limitations

### Student Access to the Institutional Org

Students are not allowed to self-join the Institutional organization `tamu-edu`{target=_blank}. However, students with an employee affiliation to the University, such as a student worker or research assistant, will be able to self-join the Institutional organization. Other students need to be invited and added to a Team by an existing faculty or staff member.

### Teams

Teams can be created in either organization using a web form. Nesting a team is not yet supported but is planned to be in the future.

See the main page on [Teams](teams.md) for more information.

### Secrets

Organization secrets are not enabled. Set secrets that a must be shared between multiple repositories on each repository individually. It is best practice to use a unique secret for each repository.

Github is exploring Team-level secrets, but the feature has not made it onto their public road map.

[Contact us](mailto:github@tamu.edu) if you need assistance updating or managing repository secrets.
