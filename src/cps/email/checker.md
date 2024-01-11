```admonish info
This site is a work in progress and will be updated regularly.  Please check back frequently for updates.
```

# DMARC Check Website

The DMARC Check tool can check your email authentication compliance with DMARC.

<https://dmarc-check.itsec.tamu.edu>

After navigating to this site, you will be presented with a unique email address in the form of:

`##########@dmarc.itsec.tamu.edu`

This is a one-time-use address to which you can send a message from an external email system (marketing platforms, cloud apps, etc.) to check DMARC compliance. Simply create a test message with this address as a recipient, and send it.  Be patient!

```admonish warning
Email services can queue messages for several minutes. If you navigate away from this page before the message is received, you will need to start over.
```

Once received, the tool will attempt to automatically evaluate your message for compliance and display the results on the screen. Should any action be required to become compliant, you will be presented with a list of resources that you can reference.

If the tool reports a DKIM failure, you can follow the steps below for your specific platform to enable DKIM. If your platform is not listed below and our generic guidelines do not apply, please contact `security@tamu.edu` for assistance.

```admonish info
This tool is only useful for email sent from a from a third party mailer as `tamu.edu` or a subdomain.

For additional information see [KB0021277](https://itselfservice.tamu.edu/tamucs?id=tamucs_kb_article&sys_id=KB0021277) for more information on sending messages using third party mailers.
```
