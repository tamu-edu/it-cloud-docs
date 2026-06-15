# Azure App Service

- **Rule:** App Services may not be exposed to the public internet and must be secured to private access only.
- **Action:** This can be achieved by using Private Endpoints to connect App Services to the VNet and ensuring that all inbound and outbound traffic is directed through the hub gateways for security scanning and logging.

* App Service "Public Access" property must be either set to "Disabled" or "Enabled with Limited Access" together with a default Deny rule in order to prevent direct public access.
* App Service must be connected to the VNet via a private subnet with a User Defined Route (UDR) directing outbound traffic to the hub firewall and with no NSG rules allowing inbound traffic from the public internet.
