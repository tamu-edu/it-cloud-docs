# FAQ
```admonish info
This site is a work in progress and will be updated regularly.  Please check back frequently for updates.
```

## Why are these changes necessary?

Email providers like, Gmail and Yahoo are implementing stricter sender guidelines.  These guidelines follow best practices and aim to reduce the amount of fraudulent spam and phishing messages that make it into user's inboxes.  Aditionaly, these guidelines will likely become standards for all email providers and senders.

## When are these changes needed?

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

## What does Texas A&M's implementation of these standards mean for me?

Exact policies and requirements are still being finalized.  The guidelines provided by Google and Yahoo above will heavily influence the final policy and implementation for Texas A&M services.

The implementaion will include:

- SPF records to be inherited from tamu.edu, or will include tamu.edu’s SPF record with a softfail
- DKIM signing will be implemented on all outbound mail gateways
- Third party mailers and cloud applications will utilize DKIM signing for authentication when delivering on behalf of all tamu.edu domains.
- TLS will be used to deliver all outbound mail
- DMARC compliance will be required for all outbound mail

## What happens if a 'tamu.edu' subdomain does not meet these standards?

Failure to comply with these guidelines by February 2024 may result in emails being flagged as spam, quarantined or rejected. Email flagged as spam could significantly impact your reputation and in turn, your communication and marketing efforts.

Repeated violations might lead to your domain or IP address being blacklisted, severely affecting your ability to send emails to users of these services.

## How do I know if my subdomain/service is affected?

Mail sent using Texas A&M approved email and marketing platforms should continue to work as intended.  However, services that may be affected are:

- Mail sent from third party mailers (marketing platforms like MailChimp and SendGrid)
- Mail sent directly from cloud applications (SaaS providers, AmazonSES, etc)
- Mail sent externally that does not flow through approved email gateways

```admonish warning
If you use a service that impersonates the root 'tamu.edu' domain or 'tamu.edu' subdomains, you may be affected.

You can use the [DMARC Check Website](https://dmarc-check.itsec.tamu.edu) to check your DMARC compliance.

For more information on these tools see the [DMARC Check](./checker.md) and [DMARC Report](./reporting.md) pages.
```
## What should my SPF record look like?

All 'tamu.edu' subdomains should be configured to inherit from the root 'tamu.edu' domain and should be set to:

`v=spf1 redirect:tamu.edu`

As part of our effort to comply with Google and Yahoo email sender requirements, we will be creating SPF records for all 'tamu.edu' subdomains.  For more information see the [SPF](./spf.md) page.

## How can I check my SPF record?

The easiest way to check your SPF record is to query DNS.  For detailed instructions see the [SPF](./spf.md) page.

## How can I check my DKIM record?

The easiest way to check your DKIM record is to query DNS.  For detailed instructions see the [DKIM](./dkim.md) page.

## How can I check my DMARC compliance?

The [DMARC Check website](https://dmarc-check.itsec.tamu.edu) is an automated tool that can be used to check your email authentication compliance with DMARC.

For more information on this tool see the [DMARC Check](./checker.md) page.

## How can I find who is sending email on my behalf?

See the [Resources and Tools](./tools.md) page.

## Do all messages require one-click unsubscribe?

No. One-click unsubscribe is required only for commercial, promotional messages. Transactional messages are excluded from this requirement. Some examples of transactional messages are password reset messages, reservation confirmations, and form submission confirmations.

```admonish info
Senders that already include an unsubscribe link in their messages have until June 1, 2024 to implement one-click unsubscribe in all commercial, promotional messages.
```

## What tool(s) can I use to manage my subdomain's reputation, deliverability and spam metrics?

See the [Resources and Tools](./tools.md) page.
