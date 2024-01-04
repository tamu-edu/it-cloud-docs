# DMARC

Domain-based Message Authentication, Reporting & Conformance([DMARC](https://dmarc.org)) is an email standard designed to prevent spammers from using a domain to send email without the domain owner’s permission.  DMARC helps senders and receivers determine if a messages is legitimate.  DMARC provides for is an email authentication, policy, and reporting protocol.

1) **Email Authentication** - DMARC combines the authorization and authentication results of two other protocols, SPF and DKIM, to determine whether email sent from your domain is authentic.
2) **Email Policy** - DMARC publishes a public policy instructing recipient servers how to respond if they receive email from your domain that was determined to be inauthentic.
3) **Email Reporting** - DMARC provides reporting mechanisms for domain owners to monitor, assess, and confirm that mail being sent from their domain is legitimate.

DMARC Policies are creating using a simple DNS TXT Record.  Here is a sample DMARC record:

```shell
v=DMARC1; p=reject; rua=mailto:postmaster@example.com, mailto:dmarc@example.com; pct=100; adkim=s; aspf=s
```

For a message to pass DMARC authentication, it must pass two steps.  First it must pass SPF and/or DKIM authentication.  Second, DMARC must pass domain alignment for either SPF or DKIM, whichever passed the first step.  Domain Alignment ensures that the email address in the "From:" header is the actual sender of the message. This means that if SPF passed authentication, it must also pass a SPF domain check.  A SPF domain check is ensures that the Envelope "From:" (or Return-Path address) and the "From:" header are the aligned.  On the other hand, if DKIM passed authentication, it must also pass a DKIM domain check.  The DKIM domain check ensures that the DKIM signing domain (`d=example.com`) aligns with the "From:" header address.

## DMARC Requirements

In order to protect email and comply with upcoming requirements from large email providers like Google and Yahoo, all 'tamu.edu' subdomains will inherit the root 'tamu.edu' dommain's DMARC policy.  In addition, 3rd Party Mailers and cloud applications will need to utilize DKIM signing for authentication when delivering on behalf of the root 'tamu.edu' domain and for 'tamu.edu' subdomain.

All outgoing mail or mail sent from third party mailers/cloud applications, will pass DMARC.

## Check DMARC Record

The 'tamu.edu' subdomains will not have DMARC records, but will inherit from the root 'tamu.edu' domain.  To look up the 'tamu.edu' domain's DMARC record:

1) Open the console or command line on your computer.
2) Type `nslookup -q=txt _dmarc.tamu.edu`.
3) Press "Enter" to execute the command.
4) The output will display the DMARC record for the root 'tamu.edu' domain.

```shell
nslookup -q=txt _dmarc.tamu.edu
Server:         128.194.254.1
Address:        128.194.254.1#53

_dmarc.tamu.edu text = "v=DMARC1;p=quarantine;sp=none;fo=1;rua=mailto:dmarc@tamu.edu;ruf=mailto:dmarc@tamu.edu"
```
