
# DMARC

```admonish info
This site is a work in progress and will be updated regularly.  Please check back frequently for updates.
```

Domain-based Message Authentication, Reporting & Conformance([DMARC](https://dmarc.org)) is an email standard designed to prevent spammers from using a domain to send email without the domain owner’s permission.  DMARC helps senders and receivers determine if a messages is legitimate.  DMARC provides for is an email authentication, policy, and reporting protocol.

1) **Email Authentication** - DMARC combines the authorization and authentication results of two other protocols, SPF and DKIM, to determine whether email sent from your domain is authentic.
2) **Email Policy** - DMARC publishes a public policy instructing recipient servers how to respond if they receive email from your domain that was determined to be inauthentic.
3) **Email Reporting** - DMARC provides reporting mechanisms for domain owners to monitor, assess, and confirm that mail being sent from their domain is legitimate.

DMARC Policies are creating using a DNS TXT Record.  Here is a sample DMARC record:

```shell
v=DMARC1; p=reject; rua=mailto:postmaster@example.com, mailto:dmarc@example.com; pct=100; adkim=s; aspf=s
```

For a message to pass DMARC authentication, it must pass two steps.

1) Pass SPF and/or DKIM authentication.
2) Pass domain alignment for either SPF or DKIM, for whichever protocol passed in the first step.

```admonish info
Domain Alignment ensures that the email address in the "From:" header is the actual sender of the message. A SPF domain check ensures that the Envelope "From:" (or Return-Path address) and the "From:" header are aligned. The DKIM domain check ensures that the DKIM signing domain (`d=example.com`) aligns with the "From:" header address.
```

## DMARC Requirements

All `tamu.edu` subdomains will inherit the root `tamu.edu` dommain's DMARC policy. All outgoing mail or mail sent from third party mailers including cloud applications, will need to pass DMARC to ensure deiliverability.

## Check DMARC Record

The `tamu.edu` subdomains will not have DMARC records, but will inherit from the root `tamu.edu` domain.  To look up the 'tamu.edu' domain's DMARC record:

1) Open a console or command line on your computer.
2) Type `nslookup -q=txt _dmarc.tamu.edu`.
3) Press "Enter" to execute the command.
4) The output will display the DMARC record for the root `tamu.edu` domain.

```shell
nslookup -q=txt _dmarc.tamu.edu
Server:         128.194.254.1
Address:        128.194.254.1#53

_dmarc.tamu.edu text = "v=DMARC1;p=quarantine;sp=none;fo=1;rua=mailto:dmarc@tamu.edu;ruf=mailto:dmarc@tamu.edu"
```
