module "networking" {
  source              = "./modules/networking"
  vnet-name           = "${var.type}-vnet"
  resource-group-name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  vnet-address-space  = ["29.0.0.0/16"]
  subnet-details = {
    AzureFirewallSubnet = "29.0.0.0/24"
    application-gateway = "29.0.1.0/24"
    web                 = "29.0.2.0/24"
    backend             = "29.0.3.0/24"
    db                  = "29.0.4.0/24"
  }
  depends_on = [ azurerm_resource_group.myrg ]
}