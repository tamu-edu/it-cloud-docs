# DMARC Check Website

```admonish info
This site is a work in progress and will be updated regularly.  Please check back frequently for updates.
```

The DMARC Check website is a tool to check your email authentication compliance with DMARC.

<https://dmarc-check.itsec.tamu.edu>

After navigating to this site, you will be presented with a unique email address in the form of:

`##########@dmarc.itsec.tamu.edu`

This is a one-time-use address to which you can send an email from an external third party mailer (marketing platforms, cloud apps, etc) to check DMARC compliance. Simply create a test email message with this address as a recipient, and send it.  Be patient!

```admonish warning
Marketing and mail services may queue mail for several minutes. If you navigate away from this page before the email is received, you will need to start over.
```

Once received, the tool will attempt to automatically evaluate your message for compliance and display the results on the screen. Should any action be required to become compliant, you will be presented with a list of resources that you can reference.

If the tool reports a DKIM failure, you can follow the steps below for your specific platform to enable DKIM. If your platform is not listed below and our generic guidelines do not apply, please contact `security@tamu.edu` for assistance.

```admonish info
For additional information see [KB0021277](https://itselfservice.tamu.edu/tamucs?id=tamucs_kb_article&sys_id=KB0021277) for more information on sending mail using third party mailers.
```
```admonish warning
This tool is only useful for email sent from an '@tamu.edu' domain or subdomain that has been sent from a third party mailer.
```