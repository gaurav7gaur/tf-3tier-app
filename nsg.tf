module "nsgs" {
  source   = "./modules/nsg"
  location = azurerm_resource_group.myrg.location
  rg-name  = azurerm_resource_group.myrg.name
  nsgs = {
    "firewall-nsg" = [
      {
        name                       = "Allow-AppGateway-Inbound"
        priority                   = 150
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "Internet"
        destination_address_prefix = tolist(module.networking.subnet-address-range["AzureFirewallSubnet"])[0]
      },
      {
        name                       = "Deny-Other-Traffic"
        priority                   = 200
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ],
    "app-gateway-nsg" = [
      {
        name                       = "Allow-Firewall-Inbound"
        priority                   = 150
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = tolist(module.networking.subnet-address-range["AzureFirewallSubnet"])[0]
        destination_address_prefix = tolist(module.networking.subnet-address-range["application-gateway"])[0]
      },
      {
        name                       = "Deny-All-Else"
        priority                   = 300
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ],
    "web-nsg" = [
        {
        name                       = "Allow-app-gateway-in"
        priority                   = 150
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = tolist(module.networking.subnet-address-range["application-gateway"])[0]
        destination_address_prefix = tolist(module.networking.subnet-address-range["web"])[0]
      },
      {
        name                       = "deny-all-else"
        priority                   = 250
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Allow-Backend-in"
        priority                   = 175
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = tolist(module.networking.subnet-address-range["backend"])[0]
        destination_address_prefix = tolist(module.networking.subnet-address-range["web"])[0]
      },
      {
        name                       = "Deny-Internet-Out"
        priority                   = 300
        direction                  = "Outbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = tolist(module.networking.subnet-address-range["web"])[0]
        destination_address_prefix = "Internet"
      }
    ],
    "backend-nsg" = [
      {
        name                       = "Allow-WebApp-In"
        priority                   = 150
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = tolist(module.networking.subnet-address-range["web"])[0]
        destination_address_prefix = tolist(module.networking.subnet-address-range["backend"])[0]
      },{
        name                       = "Allow-DB-in"
        priority                   = 175
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = tolist(module.networking.subnet-address-range["db"])[0]
        destination_address_prefix = tolist(module.networking.subnet-address-range["backend"])[0]
      },
      {
        name                       = "Deny-All-Else"
        priority                   = 300
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ],
    "db-nsg" = [
      {
        name                       = "Allow-Backend-In"
        priority                   = 150
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = tolist(module.networking.subnet-address-range["backend"])[0]
        destination_address_prefix = tolist(module.networking.subnet-address-range["db"])[0]
      },
      {
        name                       = "Deny-All-Else"
        priority                   = 200
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }

  nsg-assoc = {
   /*
    "firewall-nsg" = {
      subnet-id = module.networking.subnet-ids["AzureFirewallSubnet"]
    },
    */
    "app-gateway-nsg" = {
      subnet-id = module.networking.subnet-ids["application-gateway"]
    },
    "web-nsg" = {
      subnet-id = module.networking.subnet-ids["web"]
    },
    "backend-nsg" = {
      subnet-id = module.networking.subnet-ids["backend"]
    },
    "db-nsg" = {
      subnet-id = module.networking.subnet-ids["db"]
    }
  }

  depends_on = [module.networking]
}