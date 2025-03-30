output "fw-policy-id" {
  value = azurerm_firewall_policy.policy.id
}
output "fw-id" {
  value = azurerm_firewall.fw.id
}
output "fw-p-ip" {
  value = azurerm_public_ip.fw-pip.ip_address
}
output "ap-gw-p-ip" {
  value = azurerm_public_ip.ag-pip.ip_address
}
output "fw-pvt-ip" {
  value = azurerm_firewall.fw.ip_configuration[0].private_ip_address
}