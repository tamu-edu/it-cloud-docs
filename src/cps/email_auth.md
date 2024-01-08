```admonish info
This site is a work in progress and will be updated regularly.  Please check back frequently for updates.
```

# Email Authentication

Email authentication (or email validation) is the process used to verify the source and legitimacy of an email message.  Utilizing email authentication helps to protect against email threats, such as phishing, fraud and spam.  To understand email authentication, it is important to understand the [protocols](./email/protocols.md) used.

To increase email deliverability and comply with requirements from email providers such as [Google](https://support.google.com/mail/answer/81126?hl=en#:~:text=1%20Set%20up%20SPF%20and%20DKIM%20email%20authentication,rate%20of%200.30%25%20or%20higher.%20...%20More%20items) and [Yahoo](https://senders.yahooinc.com/best-practices/), Technology Services is expanding the use of these protocols to all ```tamu.edu``` subdomains, often referred to as boutique domains.

At minimum, mail sent to external recipients will need to implement both [SPF](./email/spf.md) and [DKIM](./email/dkim.md), and will need to pass [DMARC](./email/dmarc.md). This has already been implemented for the root domain, ```tamu.edu```.

For additional requirements, information and frequently asked questions, visit the other pages in this section.