# Azure Bastion

- **Rule:** Direct RDP/SSH access to virtual machines from the public internet is not permitted. Administrative access to VMs in spoke VNets must be performed through the centrally managed Azure Bastion service in the hub VNet.
- **Action:** Use the shared hub-managed Azure Bastion instance to connect to your VMs over RDP/SSH via the Azure portal. No per-spoke Bastion deployment is required or permitted.

- VMs must not have public IP addresses assigned for administrative access.
- NSGs on VM subnets should permit inbound RDP (3389) and/or SSH (22) traffic from the hub Bastion subnet (`AzureBastionSubnet`) address range for administrative access via Azure Bastion.
- The shared Bastion is available to all spokes peered to the hub. Because spokes are peered to the hub VNet, the hub Bastion automatically appears as a connection option in the Azure portal when connecting to any VM in a peered spoke — no additional configuration is required by the customer.
- Bastion access is governed by Azure RBAC. Users must have at least `Reader` on the VM, the VM's NIC, and the Bastion resource to initiate a session. Request access through Cloud Services if your account does not see the hub Bastion as an option.
- See [Access Methods](/cloud/azure/network/access_methods.md) for the full list of approved administrative access patterns.

## Implementation Pattern

### Shared Hub Bastion

Cloud Services operates a single Azure Bastion instance in the hub VNet that is shared across all customer spokes. Because your spoke VNet is peered to the hub, the Bastion service is reachable from any VM in your spoke without any additional networking configuration on your part.

When you open a VM in the Azure portal and select **Connect → Bastion**, the portal will automatically detect and offer the hub Bastion instance. You do not need to deploy your own Bastion, create an `AzureBastionSubnet` in your spoke, or configure peering specifically for Bastion - it is handled centrally.

For background and feature details, see the Microsoft documentation:
- [What is Azure Bastion?](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview)
- [Connect to a VM using Bastion (Windows)](https://learn.microsoft.com/en-us/azure/bastion/bastion-connect-vm-rdp-windows)
- [Connect to a VM using Bastion (Linux)](https://learn.microsoft.com/en-us/azure/bastion/bastion-connect-vm-ssh-linux)
- [Bastion and VNet peering](https://learn.microsoft.com/en-us/azure/bastion/vnet-peering)

### Connecting to a VM

Follow the Microsoft how-to for [connecting to a VM via Bastion from the Azure portal](https://learn.microsoft.com/en-us/azure/bastion/bastion-connect-vm-rdp-windows#connect). The key points for the TAMU managed network are:

1. Navigate to your VM in the Azure portal.
2. Select **Connect**, then choose the **Bastion** tab.
3. The shared hub Bastion will appear automatically as the available Bastion host. You will not be prompted to create a new one.
4. Enter your VM credentials (username/password, SSH key, or Azure AD login if configured) and select **Connect**.
5. A browser-based RDP or SSH session will open in a new tab.

> [!NOTE]
> If the Bastion option does not appear, or you receive a permissions error, confirm that:
> - Your spoke VNet is peered to the hub (this is the default for managed spokes).
> - Your account has at least `Reader` role on the VM, its NIC, and the hub Bastion resource.
> - The VM's NSG permits RDP/SSH from the `AzureBastionSubnet` range in the hub.
>
> Contact Cloud Services if any of the above need to be addressed.

### Native Client Access (Optional)

For users who prefer to use a native RDP or SSH client (rather than the browser), Azure Bastion supports tunneling through the Azure CLI. This requires the Bastion instance to be on the Standard SKU or higher, which the hub Bastion provides.

See the Microsoft documentation for [connecting using a native client](https://learn.microsoft.com/en-us/azure/bastion/connect-native-client-windows). Example:

```bash
az network bastion ssh \
  --name <hub-bastion-name> \
  --resource-group <hub-resource-group> \
  --target-resource-id <your-vm-resource-id> \
  --auth-type ssh-key \
  --username azureuser \
  --ssh-key ~/.ssh/id_rsa
```

The hub Bastion name and resource group can be obtained from Cloud Services.

## File Transfer

The shared hub Bastion is provisioned at a SKU that supports file upload/download during browser-based sessions. See [Upload and download files using Bastion](https://learn.microsoft.com/en-us/azure/bastion/vm-upload-download-native) for details. If you require file transfer functionality and it is not available in your session, contact Cloud Services.

## Migrating

If you currently rely on a public IP and direct RDP/SSH for VM administration:

1. Confirm your VM is in a spoke VNet peered to the hub (managed spokes already are).
2. Update the VM's NSG to allow inbound RDP/SSH from the hub `AzureBastionSubnet` range and remove rules permitting RDP/SSH from the public internet.
3. Test connectivity by opening the VM in the Azure portal and selecting **Connect → Bastion**. Confirm the shared hub Bastion is offered and that you can establish a session.
4. Once validated, remove the public IP from the VM's NIC.
5. Update any operational runbooks or documentation referencing the previous public IP-based access pattern.

> [!NOTE]
> Removing the public IP will immediately end any active RDP/SSH sessions established over the public internet. Validate Bastion access first before removing public IPs in production.