output "subnet-ids" {
  value = {
    for subnet-name, subnet in azurerm_subnet.subnet : subnet-name => subnet.id
  }
}

output "subnet-address-range" {
  value = {
    for subnet-name, subnet in azurerm_subnet.subnet : subnet-name => subnet.address_prefixes
  }
}