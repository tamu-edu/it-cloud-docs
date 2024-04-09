# Budgets and Finances

Kion provides detailed insights into cloud spending, identifies ways to save money, and offers tools to control cloud costs. It helps you track spending and budgets in detail, discover ways to save money by optimizing or removing unused cloud resources, and optionally set spending limits that automatically take action if costs get too high.

## How Cloud Spending Works

Cloud spending is based on the resources you use in the cloud. Each cloud provider has a different pricing model, but most charge based on the resources you use, such as virtual machines, storage, and data transfer, and the time you use them. Technology Services bills you based on the FAMIS account(s) provided for the actual resources you use based on the cloud provider's pricing model, without any markup.

If you have multiple cloud accounts billed to the same FAMIS account, the bill from Technology Services will be an aggregate. You can use Kion to view individual cloud account spending. 

You may see charges on your cloud accounts related to services you did not directly use. For example, you may see charges for data transfer, storage, or other services that are used by other services you are using. These charges are typically small but can add up over time. There are other services that are free up to a certain limit, such as the number of API calls you can make to a service. If you exceed this limit, you will be charged for the additional usage. Finally, there are services related to security, logging, and monitoring that are required for compliance or best practices. These services may have a cost associated with them, but they are necessary for the operation of your cloud resources. Even if you do not directly use these services, you may still be charged for them.


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

