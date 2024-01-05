# Email Authentication Protocols
```admonish info
This site is a work in progress and will be updated regularly.  Please check back frequently for updates.
```
SPF, DKIM and DMARC function as email authentication protocols.  These protocols help providers verify the origin of a message and whether it comes from a trustworthy source.

Technology Services has enabled DMARC for the root tamu.edu domain. DMARC uses both the DKIM and SPF protocols to verify the legitimacy of an email. While this document is intended to explain what these protocols are and how to use them, consider it an overview. This topic is complex.

## What is DMARC?

Domain-based Message Authentication, Reporting & Conformance ([DMARC](https://dmarc.org/)) is a protocol that provides three unique mechanisms to protect email domains.

  1) DMARC combines the authorization and authentication results of two other protocols, SPF and DKIM, to determine whether email sent from your domain is authentic.
  2) DMARC publishes a public policy instructing recipient servers how to respond if they receive email from your domain that was determined to be inauthentic.
  3) DMARC provides reporting mechanisms for domain owners to monitor, assess, and confirm that mail being sent from their domain is legitimate.

See [DMARC](./dmarc.md) for more details.
## What is SPF?

Sender Policy Framework ([SPF](https://en.wikipedia.org/wiki/Sender_Policy_Framework)) is a method of email authorization used to specify which servers are permitted to send on behalf of a domain. SPF helps prevent spoofing, where an email is made to appear as if it came from an organization when, in reality, it did not. 

```admonish info
SPF operates on the [email envelope](https://datatracker.ietf.org/doc/html/rfc5321#section-2.3.1), not the body or message header.
```
```admonish info
SPF is an older protocol and limits the number of networks that can be included in a policy. Due to the size and scope of Texas A&M University's email infrastructure, combined with the security conncerns surrounding IP address trust, SPF is not a sustainabile model for authenticating mail.
```
See [SPF](./spf.md) for more details.

## What is DKIM?

Domain Keys Identified Mail ([DKIM](https://dkim.org/)) is a method of email authentication used to ensure that messages have not been altered in-flight, and that the message header sender (the sender that is displayed to the recipient in their mail client) is authorized to send email on behalf of a domain.

DKIM is implemented with DNS records, additional email headers, and cryptographic signing techniques. Every major mailing service provides functionality for the protocol. See [KB0021277](https://itselfservice.tamu.edu/tamucs?id=tamucs_kb_article&sys_id=KB0021277) for more information on sending mail using third party mailers.
```admonish info
DKIM is a newer, superior method for authentitating mail using a cryptographic key pair. It also scales well, because a selector can be created for each third-party service. Unlike SPF, it does not rely on IP addresses for determining authenticity.
```
See [DKIM](./dkim.md) for more details