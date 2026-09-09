# Personal Azure Subscriptions

This article explains how to create and manage an Azure subscription for personal use without associating it with the TAMU Azure tenant. Use a personal Microsoft account to own the subscription, and follow the transfer instructions below if you accidentally created it with your TAMU NetID.

## Create a personal subscription

Create personal Azure subscriptions with a personal Microsoft account that uses a personal email address, such as Gmail or Yahoo. Do not use your TAMU NetID.

Microsoft associates subscriptions created with a TAMU NetID, which is a Microsoft work or school account, with the TAMU Azure tenant. As a result, the subscription may be subject to TAMU policies and restrictions even if you intend to use it for personal purposes.

For more information, see [What's the difference between a Microsoft account and a work or school account?](https://support.microsoft.com/en-us/accounts-billing/manage/what-s-the-difference-between-a-microsoft-account-and-a-work-or-school-account).

If you need a personal Microsoft account, create one at [https://signup.live.com](https://signup.live.com).

## Transfer an existing personal subscription

If you created a personal subscription with your TAMU NetID, transfer it to a personal Microsoft account. The transfer removes the subscription from the TAMU Azure tenant and associates it with your personal Microsoft account.

### Before you begin

- Decide whether you want to keep the subscription. If you no longer need it, [cancel and delete the Azure subscription](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/cancel-azure-subscription) instead.
- Make sure you have a personal Microsoft account. Create one at [https://signup.live.com](https://signup.live.com) if needed.
- If you have never used the personal account with Azure, create a personal Azure subscription with it first. This enables the account to receive the subscription transfer. Create one at [https://azure.microsoft.com/en-us/free/](https://azure.microsoft.com/en-us/free/).

> [!Important]
> If you do not create a personal subscription first, your account will not be fully registered with Azure and cannot receive the subscription transfer.

> [!NOTE]
> A personal subscription requires a payment method (such as a credit card), but you can cancel and delete the subscription after the transfer is complete to avoid  unintended charges.

### Transfer the subscription

1. **Find your personal tenant ID.** Sign in to the Azure portal with your personal Microsoft account.
   1. Search for **Entra ID** and select it.
   2. Under **Basic Information**, copy the **Tenant ID**. This is the directory ID for your personal Azure tenant.
2. **Start the transfer from the TAMU tenant.** Sign in to the Azure portal with your TAMU NetID and open the subscription you want to transfer.
   1. On the subscription's **Overview** page, select **Change directory**.
   2. When asked whether your current account will accept the transfer, select **No**.
   3. Enter the email address for your personal Microsoft account.
   4. Enter the personal tenant ID you copied in step 1.
   5. Select **Continue** to start the transfer, then copy the URL for the transfer acceptance page.
3. **Accept the transfer.** Sign in to the Azure portal with your personal Microsoft account and open the transfer acceptance URL.
   1. Review the subscription details.
   2. Select **Accept**.

The transfer may take a few minutes. To verify that it completed, sign in to the Azure portal with your personal Microsoft account and check the subscription's **Overview** page. The subscription should no longer be associated with the TAMU Azure tenant.

If you created a personal Azure subscription in the preparation step and no longer need it, you can optionally cancel and delete it to avoid confusion or unintended charges. See [Cancel and delete an Azure subscription](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/cancel-azure-subscription) for instructions.
