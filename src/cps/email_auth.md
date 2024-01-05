# Email Authentication
```admonish info
This site is a work in progress and will be updated regularly.  Please check back frequently for updates.
```
Email authentication (or email validation) is the process used to verify the source and legitimacy of an email message.  Utilizing email authentication helps to protect against email threats, such as phishing, fraud and spam, while also helping ensure that your messages reach the inbox.

When understanding email authentication and security at Texas A&M, it is important to understand the [protocols](./email/protocols.md) that make up email authentication.

SPF, DKIM and DMARC have been implemented for the 'tamu.edu' domain.

In order to increase email deliverability and comply with requirements from email providers like Google and Yahoo, we are expanding the use of these email authentication protocols to all 'tamu.edu' subdomains, or boutique addresses (`subdomain.tamu.edu`), that send to external recipients.  At a minimum, all 'tamu.edu' subdomains that send to external recipients will need to implement both SPF and DKIM and will need to pass DMARC.

For additional requirements, information and frequently asked questions, visit the other pages in this section.