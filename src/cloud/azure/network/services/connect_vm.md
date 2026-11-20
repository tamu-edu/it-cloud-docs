# Azure Virtual Machines

- **Rule:** A Virtual Machine (VM) may not be directly exposed to the public internet and must be deployed with private-only network connectivity in a customer spoke virtual network (VNet).
- **Action:** Deploy VM into a private subnet with default outbound routing through the hub firewall (FW), and work with Cloud Services to ensure ingress through centralized hub services.

- VM network interface must not have a Public IP associated.
- VM subnet must have a User Defined Route (UDR) that sends outbound traffic to the hub-centralized firewall for inspection and logging.
- NSGs should follow least privilege and allow only required inbound traffic from approved sources (for example, campus network ranges, VPN, or explicitly approved private peer ranges).
- If the VM hosts a workload that must be reachable from the internet, request Cloud Services configuration of hub firewall DNAT rules and any required DNS updates.
- Administrative protocols (RDP, SSH, WinRM, etc.) must not be published to the internet; use private access methods from trusted networks. See [Access Methods](/cloud/azure/network/access_methods.md) for details.

## Implementation Pattern

Use this sequence for both new deployments and updates to existing VM workloads:

1. Create or select a private workload subnet and confirm it is associated with the default egress UDR to the hub firewall.
2. Deploy the VM NIC into that subnet with no Public IP.
3. Attach an NSG (subnet-level or NIC-level) with least-privilege rules for only approved source ranges and required ports.
4. Validate private administrative access from approved networks (campus/VPN) before placing the workload in service.

If internet ingress is required, submit a Cloud Services request for hub AFD, firewall, and/or DNS updates.

## Steps in Azure Portal

The steps below are generalized for a new or existing VM.

1. From the VM resource view, click `Networking > Network settings` to see an overview of the attached NIC configuration. If changes need to be made, the VM needs to be shutdown before continuing.
1. Click the NIC name (or when creating a new NIC) to make changes:
   - Select your VNet and private subnet.
   - `Associate public IP address` should be unchecked.
1. Open the NSG on the NIC/subnet (<em>ex. NIC Overview > Properties: Click the NSG name under `Network security group`</em>) > `Inbound security rules`, and verify only approved source ranges and required ports are allowed.
1. Open the attached NIC -> `IP configurations` and verify there is no associated Public IP.
1. Open the target subnet -> `Route table` and verify hub FW UDR (see [Route Tables](/cloud/azure/network/creating_subnets.md#route-tables) in **Creating Subnets** for details) is associated.

## Migrating

To convert an existing public Virtual Machine to private:

**Note step 6 below:** If your application needs to be publicly accessible off campus, be sure Cloud Services is available to configure the new origin once it's ready.

1. Create a private subnet of the appropriate size in the provided TAMU spoke vnet, and include the provided UDR and the existing Network Security Group.
2. Disconnect the Public IP resource from the NIC.
3. Review and record the Virtual Machine's specific configuration (VM Size (SKU), attached os and data disks) and delete the VM: **Do not delete attached disks**
4. Create a new VM in the same configuration as the one just deleted attached to the new subnet: This may be easiest in Azure Portal by locating the detached disk and selecting **Create VM** from it.
5. Validate connectivity from within the VNet (e.g. from a VM or via campus VPN) per NSG open ports. Connecting over ssh, for example, should work as it worked before destroy/recreate. Any applications set to run at start should also come up.
6. Submit a Cloud Services request to configure an AFD origin and endpoint for the App Service if it needs to remain publicly accessible off campus/vpn.
7. Update any DNS records or application configurations that previously pointed to the public App Service hostname to use the new AFD endpoint.

## Example Terraform Snippets

### Private NIC (No Public IP)

```hcl
resource "azurerm_network_interface" "vm" {
  name                = "nic-vm-workload"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.vm.id
    private_ip_address_allocation = "Dynamic"
  }
}
```


### VM Attached to Private NIC with NSG

```hcl
resource "azurerm_network_security_group" "vm" {
  name                = "nsg-vm-workload"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-ssh-from-hub-firewall-only"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.hub_firewall_cidr
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "vm" {
  network_interface_id      = azurerm_network_interface.vm.id
  network_security_group_id = azurerm_network_security_group.vm.id
}
```

### VM Attached to Private NIC

```hcl
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-workload-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B2s"
  admin_username      = "azureuser"

  network_interface_ids = [azurerm_network_interface.vm.id]

  ...
}
```
