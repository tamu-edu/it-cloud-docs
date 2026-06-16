# Azure Virtual Machines

- **Rule:** A Virtual Machine (VM) may not be directly exposed to the public internet and must be deployed with private-only network connectivity in a customer spoke virtual network (VNet).
- **Action:** Deploy VM into a private subnet with default outbound routing through the hub firewall (FW), and work with Cloud Services to ensure ingress through centralized hub services.

- VM network interface must not have a Public IP associated.
- VM subnet must have a User Defined Route (UDR) that sends outbound traffic to the hub-centralized firewall for inspection and logging.
- NSGs should follow least privilege and allow only required inbound traffic from approved sources (for example, campus network ranges, VPN, or explicitly approved private peer ranges).
- If the VM hosts a workload that must be reachable from the internet, request Cloud Services configuration of hub firewall DNAT rules and any required DNS updates.
- Administrative protocols (RDP, SSH, WinRM, etc.) must not be published to the internet; use private access methods from trusted networks. See [Access Methods](../access_methods.md) for details.

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
1. Open the target subnet -> `Route table` and verify hub FW UDR (see [Route Tables](../creating_subnets.md#route-tables) in **Creating Subnets** for details) is associated.

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
