# Email Security

Email security is the practice of protecting email accounts and communications from unauthorized access, loss, or compromise. Email authentication (or email validation) is the process used to verify the source and legitimacy of an email message.  Utilizing email authentication helps to protect against email threats, such as phishing, fraud and spam, while also helping ensure that your messages reach the inbox.

When understanding email authentication and security at Texas A&M, it is important to understand the protocols that make up email authentication.

[Email Authentication Protocols](./email/protocols.md)

The email authentication protocols of SPF, DKIM and DMARC have been implemented when sending to external recipients from the root 'tamu.edu' domain.

In order to further protect email and comply with upcoming requirements from large email providers like Google and Yahoo, we are expanding the use of the email authentication protocols to all 'tamu.edu' subdomains, or boutique addresses (`subdomain.tamu.edu`), that send to external recipients.  At a minimum, all 'tamu.edu' subdomains that send to external recipients will need to implement both SPF and DKIM and will need to pass DMARC.

- [SPF](./email/spf.md)
- [DKIM](./email/dkim.md)

For additional requirements, information and frequently asked questions see the following:

- [SPF](./email/spf.md)
- [DKIM](./email/dkim.md)
- [Monitoring/Tools](./email/tools.md)
- [Bulk Mail](./email/bulk.md)
- [Policies]()
- [FAQ](./email/faq.md)
