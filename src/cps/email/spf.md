```admonish info
This site is a work in progress and will be updated regularly.  Please check back frequently for updates.
```

# SPF

Sender Policy Framework ([SPF](https://en.wikipedia.org/wiki/Sender_Policy_Framework)) is a method of email authorization used to specify which servers are permitted to send on behalf of a domain. SPF helps prevent spoofing, where an email is made to appear as if it came from an organization when, in reality, it did not.

```admonish info
SPF operates on the [email envelope](https://datatracker.ietf.org/doc/html/rfc5321#section-2.3.1), not the body or message header.
```

SPF is implemented via DNS records which specify authorized address ranges. The [RFC](https://tools.ietf.org/html/rfc7208) limits the record to a maximum of 10 DNS queries, and a total of 255 bytes per query. These constraints limit the number of addresses an organization can authorize.

```admonish info
Publishing an invalid SPF record, including a record containing too many addresses, may result in all email from the sending domain failing delivery. It is imperative that both the integrity and legitimacy of the record be closely maintained.
```

## SPF Requirements

All 'tamu.edu' domains which send mail are required to have an SPF record in DNS. The SPF record should be configured to inherit from the root 'tamu.edu' domain.  The SPF record should be set to:

`v=spf1 redirect:tamu.edu`

```admonish info
Any `tamu.edu` domain without an existing SPF record will have the `v=spf1 redirect:tamu.edu` DNS record created.

For domains with existing SPF records, Cloud and Platform Security will work with those who use the domain to send mail. Any invalid or improper SPF records will be changed to ensure mail delivery.
```

For legacy documentation on SPF at Texas A&M see [KB0021277](https://itselfservice.tamu.edu/tamucs?id=tamucs_kb_article&sys_id=KB0012557).

## Check SPF Record

The easiest way to check an SPF record is to use the command line:

1. Open a terminal or command line on your computer.
2. Type `dig txt subdomain.tamu.edu` or `nslookup -q=txt subdomain.tamu.edu`. Replace subdomain with your `tamu.edu` subdomain name that you want to check.
3. Click "Enter" to execute the command.
4. You will see a list of TXT records associated with the domain.
5. Look for the TXT record that starts with `v=spf1`. This is the SPF record for the domain.

```shell
nslookup -q=txt itsec.tamu.edu
Server:         128.194.254.1
Address:        128.194.254.1#53

itsec.tamu.edu  text = "v=spf1 redirect=tamu.edu"
```
