# Email Authentication Protocols

Collectively, SPF, DKIM and DMARC are refered to as email authentication protocols.  These protocols help providers verify the origin of a message: whether it comes from a trustworthy source or has been faked or forged by spammers, scammers, and spoofers pretending to be someone they are not.

Texas A&M Technology Services has enabled the anti-spoofing protocol DMARC for the root tamu.edu domain. DMARC compliance is a very technical topic involving several related, though different, protocols that work together to verify the legitimacy of an email. While this document is intended to explain what these protocols are and how to use them, these concepts can be difficult to understand.

## What is DMARC?

Domain-based Message Authentication, Reporting & Conformance (DMARC) is a protocol that provides three unique mechanisms to protect email domains.

  1) DMARC combines the authorization and authentication results of two other protocols, SPF and DKIM, to determine whether email sent from your domain is authentic.
  2) DMARC publishes a public policy instructing recipient servers how to respond if they receive email from your domain that was determined to be inauthentic.
  3) DMARC provides reporting mechanisms for domain owners to monitor, assess, and confirm that mail being sent from their domain is legitimate.

## What is SPF?

Sender Policy Framework ([SPF](https://en.wikipedia.org/wiki/Sender_Policy_Framework)) is a method of email authorization used to specify which servers are permitted to send on behalf of a domain. SPF helps prevent spoofing, where an email is made to appear as if it came from an organization when, in reality, it did not. [SPF operates on the email envelope, not the body or message header.](https://itselfservice.tamu.edu/tamucs?id=tamucs_kb_article&sys_id=KB0020389)

SPF has a limitation on the number of networks that are permitted to send on behalf of a domain. Historically, due to the fact that Texas A&M University is such a large, diverse organization, we focused primarily on DKIM compliance.  However, that could be changing with recent changes from Google and Yahoo.

See [Sender Policy Framework](https://itselfservice.tamu.edu/tamucs?id=tamucs_kb_article&sys_id=KB0012557) for more details.

## What is DKIM?

Domain Keys Identified Mail (DKIM) is a method of email authentication used to ensure that messages have not been altered in-flight, and that the message header sender (the sender that is displayed to the recipient in their mail client) is authorized to send email on behalf of a domain.

DKIM is implemented with DNS records, additional email headers, and cryptographic signing techniques. While [the protocol may be very complicated](https://dkim.org/), almost every modern email service in the world provides an easy mechanism to get you set up.
