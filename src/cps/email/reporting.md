# DMARC Reporting Website

Texas A&M's DMARC record has been setup with reporting.  DMARC reports are sent by external domains and contain essential information about the authenticity status of emails sent on behalf of a domain.  Reviewing the information in the reports helps you understand what messages sent from your domain are passing SPF, DKIM, and DMARC.

The [DMARC Reporting website](https://dmarc-report.kb.us-central1.gcp.cloud.es.io:9243/) is a kibana website with dashboards containing aggregated DMARC report data.  This data can be used by technology professionals and email administrators to determine:

- What servers or third-party senders are sending mail for your domain
- What percent of messages from your domain pass DMARC
- Which servers or services are sending messages that fail DMARC
- What DMARC actions the receiving server takes on unauthenticated messages from your domain: none, quarantine, or reject.

```admonish info
The website only keeps data reported within the last 30 days.
```

## Dashboard

After navigating to this site and selecting the DMARC Summary dashboard, you will see the following:

- From Domain panel - a dropdown with a list of from domains that can be used to filter the data
- Total Message Count - the number of messages reported on for the domain in the last 30 days
- SPF Alignment - pie chart that displays the percentage messages that pass or fail SPF
- DKIM Alignment - pie chart that displays the percentage messages that pass or fail DKIM
- DMARC Passage - pie chart that displays the percentage messages that pass or fail DMARC
- DMARC Passage Over Time - chart of how many messages passed DMARC over time
- Message Disposition over Time -  chart of the number of messages that had a specific DMARC policy applied; if the status is 'none', that means that the policy was not applied and that the email reached the recipient's inbox, whereas 'quarantine' and 'reject' mean the policy was applied and that the message was either quarantined or rejected
- Reporting Organizations - a table with a list of organizations that are sending DMARC reports for the specified domain
- Top 2000 Message Sources by Reverse DNS - a table with a list of sending servers grouped by the base domain in their reverse DNS
- Message Volume by Header From - a table with a list of email from domains, sorted by message volume
- Map of Message Source Countries - a map of the world outlining how many messages were received from each country
- Message Source Countries - a table with the number of messages received from each country on the map
- Top 1000 Message Source IP Addresses - a table with a breakdown of the top 1000 message source IPs
- Overview - a table that provides an overall look at the DMARC Report data, including if SPF and/or DKIM passed and if SPF or DKIM passed DMARC authentication
- Published Policies (as reported) - a table that provides information about which published DMARC Policy was applied
- SPF Alignment Details - a table with information on SPF, its passage and alignment (did DMARC pass using SPF)
- DKIM Alignment Details - a table with information on DKIM, its passage and alignment (did DMARC pass using DKIM)

```admonish warning
The dashboards do not provide information on the status of specific email messages. Instead, it was designed to provide insight into who is sending mail on behalf of your domain or subdomain.
```

## Use Case

The scenario is to find who is sending on behalf of a given 'tamu.edu' subdomain.

1) Login to the [ DMARC Reporting website](https://dmarc-report.kb.us-central1.gcp.cloud.es.io:9243/)
2) Select the hamburger menu -> select 'dashboard' -> select 'DMARC Summary'
3) Use the 'From Domain' dropdown to select a subdomain.  The dashboards will update based upon the selected 'From Domain'.
4) In the 'DMARC Passage' pie chart, select the three dots next to 'false' and select 'filter for'

```admonish info
By hovering your mouse over a data table value and using the magnifying glass icons, you can filter on different values.
```

The dashboards should now show data for messages that fail DMARC compliance.  The data can be filtered to see specific time periods or messages from specific organizations. Please open an ticket or send an email to [security@tamu.edu](mailto:security@tamu.edu) with the filters and search parameters used.  Cloud and Platform Security can use this information to help determine why email authentication failed and work with you to get the problem resolved.