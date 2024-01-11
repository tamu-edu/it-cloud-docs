```admonish info
This site is a work in progress and will be updated regularly.  Please check back frequently for updates.
```

# FAQ

## Why are these changes necessary?

Email providers like, Gmail and Yahoo are implementing stricter sender guidelines.  These guidelines follow best practices and aim to reduce the amount of fraudulent spam and phishing messages that make it into user's inboxes.  Additionally, these guidelines will likely become standards for all email providers and senders.

## When are these changes taking effect?

The majority of the requirements are being implemented in February of 2024.  Google is implementing these changes on February 1, 2024.  Yahoo also specifies a date of early February 2024.  However, some requirements like one-click unsubscribe are being implemented in June of 2024.

## What are the requirements from Google and Yahoo?


|All Senders|Bulk Senders (>5000 messages per day)|
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

For more information:
- [Googles Email Sender Guidelines](https://support.google.com/mail/answer/81126?sjid=8436365022205706809-NC) 
- [Yahoo's Email Sender Requirements](https://senders.yahooinc.com/best-practices/).

## What does Texas A&M's implementation of these standards mean for me?

Policies are being finalized. The guidelines provided by Google and Yahoo above will heavily influence the final policy and implementation for Texas A&M.

So far, this includes:

- SPF records to be inherited from `tamu.edu`, or will include `tamu.edu`’s SPF record with a softfail
- DKIM signing will be implemented on all outbound mail gateways
- Third party mailers and cloud applications will utilize DKIM signing for authentication when delivering on behalf of all `tamu.edu` domains.
- TLS will be used to deliver all outbound mail
- DMARC compliance will be required for all outbound mail

## What happens if a `tamu.edu` domain does not meet these standards?

Failure to comply with these guidelines by February 2024 may result in messages being flagged as spam, quarantined or rejected. This can significantly impact your domain's reputation and in turn, your communication and marketing efforts.

```admonish warning
Sustained non-compliance can lead to your domain or IP address being blocked entirely, severely affecting your ability to send any messages to users of these services.
```

## How do I know if I am affected?

These requirements apply to all messages sent from `tamu.edu` domains.

Messages sent using Texas A&M approved email and marketing platforms should continue to work as intended.  However, services that may be affected are:

- Email sent from third party mailers (marketing platforms like MailChimp and SendGrid)
- Email sent directly from cloud applications (SaaS providers, AmazonSES, etc)
- Email sent externally that does not traverse approved email gateways

```admonish warning
If you use a third-party service that sends messages on behalf of the `tamu.edu` domain or a subdomain, you should verify your compliance with the provided tools.

You can use the [DMARC Check Website](https://dmarc-check.itsec.tamu.edu) to check your DMARC compliance.

For more information, see the [DMARC Check](./checker.md) and [DMARC Report](./reporting.md) pages.
```

## What should my SPF record look like?

All `tamu.edu` subdomains should be configured to inherit from the root `tamu.edu` domain and should be set to:

`v=spf1 redirect:tamu.edu`

```admonish info
To comply with Google and Yahoo email sender requirements, SPF records will be created for all `tamu.edu` subdomains.  For more information see the [SPF](./spf.md) page.
```

## How can I check an SPF record?

The easiest way to check an SPF record is to query DNS.  For detailed instructions see the [SPF](./spf.md) page.

## How can I check a DKIM record?

The easiest way to check a DKIM record is to query DNS.  For detailed instructions see the [DKIM](./dkim.md) page.

## How can I check my DMARC compliance?

You can use the [DMARC Check Website](https://dmarc-check.itsec.tamu.edu) to check your DMARC compliance.

For more information on this tool see the [DMARC Check](./checker.md) page.

## How can I see who is sending email from a `tamu.edu` domain?

See the [Resources and Tools](./tools.md) page.

## Do all messages require one-click unsubscribe?

No. One-click unsubscribe is required only for commercial, promotional messages. Transactional messages are excluded from this requirement. Some examples of transactional messages are password reset messages, reservation confirmations, and form submission confirmations.

```admonish info
Senders that already include an unsubscribe link in their messages have until June 1, 2024 to implement one-click unsubscribe in all commercial, promotional messages.
```

## What tool(s) can I use to manage my subdomain's reputation, deliverability and spam metrics?

See the [Resources and Tools](./tools.md) page.
