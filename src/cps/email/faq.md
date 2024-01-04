# FAQ

## Why is email security important?

Email has been a primary communication tool in the workplace for more than two decades. More than 333 billion emails are sent and received daily worldwide—and employees get an average of 120 emails a day. This spells opportunity for cybercriminals who use business email compromise attacks, malware, phishing campaigns, and a host of other methods to steal valuable information from businesses. Most cyberattacks—94 percent—begin with a malicious email. Cybercrime cost more than USD$4.1 billion in 2020, with business email compromise causing the most damage, according to the FBI’s Internet Crime Complaint Center (IC3). The consequences can be severe, leading to significant financial, data, and loss of reputation.

## Why are we securing subdomains with email authentication?

Email providers like, Gmail and Yahoo are implementing new email sender guidelines.  These guidelines follow long held best practices and are an attempt to reduce the amount of fraudulent spam and phishing messages to user's inboxes.  In addition, these guidelines suggest a potential future standard for all email providers and senders.

## When are these changes happening?

The majority of the requirements are being implemented in February of 2024.  Google is implementing these changes on February 1, 2024.  Yahoo also specifies a date of early February 2024.  However, some requirements like one-click unsubscribe are being implemented in June of 2024.

## What are the requirements from Google and Yahoo?

Gmail’s New Email Sender Guidelines

|All Senders|Bulk Senders (>5000 emails per day)|
|-----|-----|
|SPF or DKIM email authentication|SPF and DKIM email authentication|
|Valid PTR Records|Valid PTR Records|
|Spam rates below 0.3%|Spam rates below 0.3%|
|Message format adhering to RFC 5322 Standard|Message format adhering to RFC 5322 Standard|
|No Gmail impersonation in From:headers|No Gmail impersonation in From:headers|
|Email forwarding requirements|Email forwarding requirements|
||DMARC email authentication|
||From:header aligned with either SPF domain or DKIM domain|
||One-click unsubscribe for marketing mail|

Yahoo's requirements follow the requirements as specified by Google.  For more information see [Googles Email Sender Guidelines](https://support.google.com/mail/answer/81126?sjid=8436365022205706809-NC) and [Yahoo's Email Sender Requirements](https://senders.yahooinc.com/best-practices/).

## What are Texas A&M's requirements?

Exact policies and requirements are still being finalized.  The guidelines provided by Google and Yahoo above will be used to finalize the requirements for Texas A&M.

However, here a few requirements that have been finalized.

- SPF records will be inherited from tamu.edu, or will include tamu.edu’s SPF record with a softfail.
- DKIM signing will be configured on the Proofpoint and Gmail for all outbound mail.
- 3rd Party Mailers will need to utilize DKIM signing for authentication when delivering on behalf of the root 'tamu.edu domain and for 'tamu.edu' subdomain.
- TLS enabled for all outgoing mail
- Utilize SPF and/or DKIM signing for DMARC alignment.

## What happens if my 'tamu.edu' subdomain fails to meet these requirements?

Failure to comply with these guidelines by February 2024 may result in emails being flagged as spam, quarantined or rejected. Email flagged as spam could significantly impact your reputation and in turn, your communication and marketing efforts.

Repeated violations might lead to your domain or IP address being blacklisted, severely affecting your ability to send emails to users of these services.

## How do I know if my subdomain/service is affected?

Mail sent using Texas A&M approved email and marketing platforms should continue to work as intended.  However, services that may be affected are:

- Mail sent from third party mailers (marketing platforms like MailChimp and SendGrid)
- Mail sent directly from cloud applications (SaaS providers, AmazonSES, etc)
- Mail sent externally that does not flow through approved email gateways

If you use a service that impersonates the root 'tamu.edu' domain or 'tamu.edu' subdomains, you could be affected.  You can use tools like the DMARC Check Website and the DMARC Report Website to check your DMARC compliance.  Please reach out to [security@tamu.edu](mailto:security@tamu.edu) if you have questions or concerns.

## What should my SPF DNS record look like?

- `v=spf1 redirect=tamu.edu`

## How can I check my SPF record?

- instructions on how to verify your spf DNS record?

## How can I check my DKIM record?

- on this list or manually with instructions

## How can I verify my DMARC compliance?

- DMARC Checker Website

## How can I find who is sending email on my behalf?

- DMARC Report Website

## Do all messages require one-click unsubscribe?

No. One-click unsubscribe is required only for commercial, promotional messages. Transactional messages are excluded from this requirement. Some examples of transactional messages are password reset messages, reservation confirmations, and form submission confirmations.

Senders that already include an unsubscribe link in their messages have until June 1, 2024 to implement one-click unsubscribe in all commercial, promotional messages.

## What tool(s) can I use to manage my subdomain's reputation, deliverability and spam metrics?

Google provides Postmaster Tools to help deliver essential insights into important metrics that can identify problem areas in email sending practices.  More information can be found under [Monitoring and Tools](./tools.md).

At this time other third party mailers like Yahoo and Apple do not provide their own version of Google's Postmaster Tools.

## Where can I learn more about Texas A&M's email policies?

- point them to documented email policies
