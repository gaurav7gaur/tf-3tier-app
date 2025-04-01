output "web-app-default-hostname" {
  value = azurerm_linux_web_app.web-app.default_hostname
}
output "back-app-default-hostname" {
  value = azurerm_linux_web_app.back-app.default_hostname
}
output "sql-server-fqdn" {
  value = azurerm_mssql_server.sql-paas.fully_qualified_domain_name
}