resource "azurerm_virtual_network" "vnet" {
  name = var.vnet-name
  location = var.location
  resource_group_name = var.resource-group-name
  address_space = var.vnet-address-space
}

resource "azurerm_subnet" "subnet" {
  for_each = var.subnet-details
  name = each.key
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [each.value]
  depends_on = [ azurerm_virtual_network.vnet ]
  
  dynamic "delegation" {
    for_each = each.key == "web" || each.key == "backend" ? [1] : []
    content {
      name = "delegation-to-app-service"
      service_delegation {
        name = "Microsoft.Web/serverFarms"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/action"
        ]
      }
    }
  }
  
  
  /*
  delegation {
    name = "delegation-to-app-service"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
  */

}

