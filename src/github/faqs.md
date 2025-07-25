# GitHub Frequently Asked Questions

### Acceptable Use
Users of the Service must follow:

* [GitHub’s Acceptable Use Policy](https://docs.github.com/en/site-policy/acceptable-use-policies/github-acceptable-use-policies)
* [Texas A&M University SAPS](http://rules-saps.tamu.edu/TAMURulesAndSAPs.aspx#29)
* [Texas A&M University Information Security Controls](https://it.tamu.edu/policy/it-policy/controls-catalog/index.php).

The Service is appropriate for many academic uses as well as some business and administrative uses. The Service is not appropriate for:

* Electronic Protected Health Information (EPHI) subject to the Health Insurance Portability and Accountability Act (HIPAA).
* Data controlled for export under Export Control Laws (EAR, ITAR).
* Personally Identifiable Information (PII), including Social Security Numbers, credit card numbers, and bank or financial account numbers.
* High Risk Activities such as those involving business records in which loss or inappropriate disclosure would result in large consequences in terms of economic loss, loss of trust, or legal liability.

### I have a repo that I'd like to migrate to tamu-edu or tamu-edu-students
Read more about the [Migration Process](/github/server/#migration-process) from github.tamu.edu

### Why do I need to move to tamu-edu or tamu-edu-students on github.com?
Background information may be found [here](/github/#github-overview)

### Where do I go to get access to tamu-edu or tamu-edu-students on github.com?
Specific details on getting started may be found [here](/github/#getting-started)

### Why is two-factor authentication required?
TAMU's Duo two-factor system only protects services that require NetID authentication, and TAMU Duo protects the TAMU GitHub organizations. However, your personal GitHub - a requirement for using GitHub - is not protected by TAMU Duo. Practicing good security hygiene enables two-factor authentication everywhere, and in our opinion, this should especially include GitHub. It is also the only way to require external collaborators, not subject to TAMU Duo, to use 2FA as required by most security controls.

### How do I authenticate to tamu-edu and tamu-edu-students?
To access either organization, you must first sign in to github.com using your personal GitHub account. Our organizations are configured to redirect you to use Texas A&M University SSO whenever accessing a non-public resource in the organizations. You must authorize any Personal Access Tokens and SSH Keys in your account to access each organization before use. Read more [about authentication with SAML single sign-on](https://docs.github.com/en/enterprise-cloud@latest/authentication/authenticating-with-saml-single-sign-on/about-authentication-with-saml-single-sign-on).


### Where do I find compliance data about github.com?
The [GitHub Security Portal](https://github.com/security) has specific information about GitHub's approach to security and compliance data for GitHub Enterprise Cloud:

* [SOC3](https://github.githubassets.com/images/modules/site/security/2021-GitHub-SOC-3-Report.pdf)
* [ISO/IEC 27001:2013](https://github-media-downloads.s3.amazonaws.com/security-reports/GitHub.com.ISO.27001.Certification.pdf)
* [GitHub Privacy Practices](https://docs.github.com/en/site-policy/privacy-policies/global-privacy-practices)
* [GDPR Compliance](https://docs.github.com/github/site-policy/github-privacy-statement#how-you-can-access-and-control-the-information-we-collect)
* [Cloud Security Alliance (CSA) STAR Registry](https://cloudsecurityalliance.org/star/registry/github-inc/services/github/)

### I have another question not already covered.  How do I get help?
If you have additional questions, contact us at <github@tamu.edu>

### Are there size limitations?
The standard storage guidelines from GitHub are available [here](https://help.github.com/articles/what-is-my-disk-quota).  
Additional information about paid services is available [here](advanced_features.md).

### Why can't I make my repository public?
New repositories can be made public, but a repo owner cannot change an existing private repo to public. To do so, please follow the instructions in the issue that was created, or contact us with your repo name.

### Can I have the same deploy key on multiple repositories?
No, GitHub does not support this.
