```admonish info
This site is a work in progress and will be updated regularly.  Please check back frequently for updates.
```

# SPF

Sender Policy Framework ([SPF](https://en.wikipedia.org/wiki/Sender_Policy_Framework)) is a method of email authorization used to specify which servers are permitted to send on behalf of a domain. SPF helps prevent spoofing, where an email is made to appear as if it came from an organization when, in reality, it did not.

```admonish note
SPF operates on the [email envelope](https://datatracker.ietf.org/doc/html/rfc5321#section-2.3.1), not the body or message header.
```

SPF is implemented via DNS records which specify authorized address ranges. The [RFC](https://tools.ietf.org/html/rfc7208) limits the record to a maximum of 10 DNS queries, and a total of 255 bytes per query. These constraints limit the number of addresses an organization can authorize.

```admonish warning
Publishing an invalid SPF record, including a record containing too many addresses, may result in all email from the sending domain failing delivery. It is imperative that the record's integrity is maintained.
```

## SPF Requirements

All domains which send mail are required to have an SPF record in DNS. The SPF record should be configured to inherit the policy of the root `tamu.edu` domain.

```admonish info
All subdomains should publish this SPF record:

`v=spf1 redirect:tamu.edu`

A subdomain which does not publish an SPF record will have the above record created.

For a subdomain with an existing an SPF record, Technology Services will work with domain custodians to validate the existing record. Invalid or improper records will be updated as necessary.
```
For legacy documentation on SPF at Texas A&M see [KB0021277](https://itselfservice.tamu.edu/tamucs?id=tamucs_kb_article&sys_id=KB0012557).

```admonish warning
Messages relayed to external systems via the gateway.tamu.edu delivery setting will not pass SPF.

These messages will not deliver to Gmail and Yahoo recipients starting in February 2024.
```

## Check an SPF Record

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
