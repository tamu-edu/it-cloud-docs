# SPF

Sender Policy Framework ([SPF](https://en.wikipedia.org/wiki/Sender_Policy_Framework)) is a method of email authorization used to specify which servers are permitted to send on behalf of a domain. SPF helps prevent spoofing, where an email is made to appear as if it came from an organization when, in reality, it did not. [SPF operates on the email envelope, not the body or message header.](https://itselfservice.tamu.edu/tamucs?id=tamucs_kb_article&sys_id=KB0020389)

SPF is implemented via DNS records which specify authorized address ranges. The [RFC](https://tools.ietf.org/html/rfc7208) limits the record to a maximum of 10 DNS queries, and a total of 255 bytes per query. These constraints limit the number of addresses an organization can authorize. Publishing an invalid SPF record, including a record containing too many addresses, may result in all email from the sending domain being blocked; it is therefore imperative that both the integrity and legitimacy of the record be closely maintained.

As an email authorization mechanism, SPF helps protect our brand identity externally, and aids in preventing phishing internally.

## SPF Requirements

In order to protect email and comply with upcoming requirements from large email providers like Google and Yahoo, all 'tamu.edu' subdomains will be required to have an SPF record in DNS. The SPF record should be configured to inherit from the root 'tamu.edu' domain.  The SPF record should be set to:

`v=spf1 redirect:tamu.edu`

In order to meet this new requirement, any 'tamu.edu' subdomain without an existing SPF record will have the `v=spf1 redirect:tamu.edu` DNS record created.

For those subdomains that have existing SPF records, Cloud and Platform Security will work with technology professionals and email administrators to transition to a `v=spf1 include:tamu.edu ~all` SPF record.  The ultimate goal will be for all subdomains to work towards a `v=spf1 redirect:tamu.edu` SPF record.

For more information on SPF see [KB0021277](https://itselfservice.tamu.edu/tamucs?id=tamucs_kb_article&sys_id=KB0021277).

## SPF Validation

The easiest way to verify your SPF record is to use the command line:

1. Open your terminal or command prompt on your computer.
2. Type in `dig txt domain.com` or `nslookup -q=txt subdomain.tamu.edu`. Replace domain.com with your 'tamu.edu' subdomain name that you want to check.
3. Click "Enter" to execute the command.
4. You will see a list of TXT records associated with the domain.
5. Look for the TXT record that starts with v=spf1. This is the SPF record for the domain.

```shell
nslookup -q=txt subdomain.tamu.edu
Server:         128.194.254.1
Address:        128.194.254.1#53

subdomain.tamu.edu        text = "v=spf1 redirect=tamu.edu"
subdomain.tamu.edu        text = "MS=AD712EA956D7B98D5A87A44852E462XXXXXXXXX"
subdomain.tamu.edu        text = "hnzuV2uq2ZoWnQftwdSvcVtniWmAP7Vx+SlD9i1kpCIdKRx7E9X5FJkrDzWgNEDy080NAoRMoX7XXXXXXXXX=="

```
