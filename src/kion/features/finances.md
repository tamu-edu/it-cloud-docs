# Budgets and Finances

Kion provides detailed insights into cloud spending, identifies ways to save money, and offers tools to control cloud costs. It helps you track spending and budgets in detail, discover ways to save money by optimizing or removing unused cloud resources, and optionally set spending limits that automatically take action if costs get too high.

## How Cloud Spending Works

Cloud spending is based on the resources you use in the cloud. Each cloud provider has a different pricing model, but most charge based on:

- **Resources used**: Virtual machines, storage, data transfer, etc.
- **Usage time**: The duration for which the resources are used.

## Billing Process

- **Technology Services Billing**: You are billed based on the FAMIS account(s) provided, reflecting the actual resources used according to the cloud provider's pricing model, with no markup.
- **Aggregate Billing**: If multiple cloud accounts are billed to the same FAMIS account, the bill from Technology Services will be an aggregate. Use Kion to view individual cloud account spending.

### Understanding Charges

- **Indirect Charges**: You may see charges for services you did not directly use, such as data transfer, storage, or other services utilized by the services you are using. These charges are typically small but can accumulate over time.
- **Free Services Limits**: Some services are free up to a certain limit (e.g., number of API calls). Exceeding this limit incurs additional charges.
- **Compliance and Best Practices**: Services related to security, logging, and monitoring, which are necessary for compliance or best practices, may have associated costs. Even if you do not directly use these services, you may still be charged for them.

### Bill Notification

Bills are sent via PCR360 with an email subject titled “Your Technology Services bill is ready to view.” Cloud cost and usage reports can be set up via Kion or the AWS, Azure, and GCP dashboards, depending on what is more appropriate for you to use, but bills are only paid via the PCR360 Customer Center.

### Viewing and Paying Bills

- To log in and view your bills, visit the PCR360 Customer Center. A NetID and password are required.
- Select "View Bill" under Quick Links in the main menu.
- Choose the desired bill from the drop-down labeled "Bill Date Range."
- Download and save your bill as a PDF/CSV file.
- Refer to the "Anatomy of Cloud Service Charges in PCR360 Technology Services Invoice" section to understand the format of your cloud service charges.

## Itemizing Charges

### Anatomy of Cloud Service Charges in PCR360 Technology Services Invoice

Cloud service bills from Technology Services billing will come from PCR360 and will look something like this:

- **2025-01-AWS-your-subscription-or-account-name**
- **2025-01-AZ-your-subscription-or-account-name**
- **2025-01-GCP-your-subscription-or-account-name**

Where:

- The first set of numbers (e.g., 2025-01) represents the year and month of the cost and usage period.
- The second set of characters (“AWS”, “AZ”, or “GCP”) refers to Amazon Web Services, Microsoft Azure, or Google Cloud Platform, respectively.

### How to Itemize Cloud Service Charges

To itemize your cloud service charges, you can use Kion or the respective Cloud Service Provider (CSP) dashboards (AWS, Azure, GCP). Here’s how you can do it:

- **Using Kion**:
    
    - Log in to Kion ([https://kion.cloud.tamu.edu/login](https://kion.cloud.tamu.edu/login)) with your credentials.
    - If you have not used the self-service request form to create a cloud account, you can log into Kion but will need to make a helpdesk ticket to request the minimal privilege access for your itemization or spend report needs.
    - Review the detailed breakdown of charges for each service and resource used.
    - Export the data if needed for further analysis or reporting.
    - For more detailed guidance, refer to the [Kion Spend Reports Documentation](https://support.kion.io/hc/en-us/articles/25335727026061-Spend-Reports).
- **Using CSP Dashboards**:
    
    - **AWS**: Log in to the AWS Management Console and follow the instructions in the [AWS Documentation on Understanding Your Bill](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/getting-viewing-bill.html) to view and analyze your usage and costs.
    - **Azure**: Log in to the Azure Portal, navigate to "Cost Management + Billing," and use the "Cost Analysis" tool to review and itemize your charges. For more detailed guidance, refer to the [Azure Cost Management Documentation](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/reporting-get-started).
    - **GCP**: Log in to the Google Cloud Console, go to the "Billing" section, and use the "Reports" or "Cost Table" to view detailed cost information. For more detailed guidance, refer to the [GCP Billing Reports Documentation](https://cloud.google.com/billing/docs/how-to/reports).

By itemizing your charges, you can gain a better understanding of your cloud spending and identify areas where you can optimize costs.

## Budgets

Kion allows you to set budgets for your cloud accounts and projects. You can set budgets for specific time periods, such as monthly, quarterly, or annually. You can also set budgets for specific services, such as EC2, S3, or RDS. 

Technology Services has pre-created a budget for each project from the dollar amount that was originally requested. Historically, this provided dollar amount has been unrealistic and out of date and will need to be adjusted. 

Kion budgets are simply groups of one or more months that have been given a specific amount of spending. Most commonly, the months in a budget reflect our Fiscal Year, which runs from September 1st to August 31st. If you have a steady workload and spending pattern, you can set a budget for the entire year by allocating the same amount to each month. However, if you have a season workload, you can allocate a different amount each month to reflect the expected spending.

Kion will automatically track both your total spending *and* your spending rate based on the budget you have set. If you are spending too quickly, Kion will show you so that you can take action to slow down your spending or adjust your budget. In the example below, the green bar represents how much you have spent, and the arrow indicates where you should be based on your budget.

<p align="center">
  <img src="img/budget_line.png" height="200" />
</p>

For more information on managing budgets, see [Managing Project Budgets](https://support.kion.io/hc/en-us/articles/9360323155853-Managing-Project-Budgets).


### Enforcement Actions

Financial enforcement actions are configurable actions you can set to trigger when a spending limit is surpassed. An enforcement action can be as simple as sending an email to a project owner or as complex as shutting down a cloud account.

Enforcement actions are set up in the Enforcements tab of a project. You can set up multiple actions to trigger at different spending thresholds. For example, you could set up an action to send an email to the project owner when spending reaches 80% of the budget and then shut down the account when spending reaches 100% of the budget.

For more information on setting up enforcement actions, see [Project Financial Enforcements](https://support.kion.io/hc/en-us/articles/360033984632-Project-Financial-Enforcements).


## Savings Opportunities

Kion provides recommendations for saving money on your cloud spending. These recommendations are based on your current spending patterns and the services you are using. We recommend reviewing these recommendations regularly to ensure you are getting the best value for your cloud spending.


## Financial Reports

Kion provides detailed financial reports to help you understand your cloud usage and spending. You can generate reports for specific time periods, services, or projects. Reports can be exported to CSV or PDF for further analysis or sharing.

The Financials tab of the project shows you the budget and spending status for the project, the spending per account, and the spend reporting tool. The spend reporting tool allows you to generate reports for specific time periods, services, or projects. Reports can be exported to CSV or PDF for further analysis or sharing. A spend report by service can be used to reconcile your cloud spending with your internal Technology Services bill.

