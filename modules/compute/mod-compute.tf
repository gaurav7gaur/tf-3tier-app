resource "azurerm_service_plan" "plan" {
  name                = var.app-service-plan-name
  location            = var.location
  resource_group_name = var.rg-name
  sku_name            = var.app-service-plan-sku //"B1"
  os_type             = var.app-os               //"Linux"
}

resource "azurerm_linux_web_app" "web-app" {
  name                = var.web-app-service-name
  location            = var.location
  resource_group_name = var.rg-name
  service_plan_id     = azurerm_service_plan.plan.id
  site_config {
    always_on = true
  }
  app_settings = var.web-app-settings
  identity {
    type = "SystemAssigned"
  }
  virtual_network_subnet_id = var.web-subnet-id
  depends_on                = [azurerm_service_plan.plan]
}

resource "azurerm_linux_web_app" "back-app" {
  name                = var.back-app-name
  location            = var.location
  resource_group_name = var.rg-name
  service_plan_id     = azurerm_service_plan.plan.id
  site_config {
    always_on = true
  }
  app_settings = var.back-app-settings
  identity {
    type = "SystemAssigned"
  }
  virtual_network_subnet_id = var.backend-subnet-id
  depends_on                = [azurerm_service_plan.plan]
}

resource "azurerm_mssql_server" "sql-paas" {
  name                         = var.sql-name
  location                     = var.location
  resource_group_name          = var.rg-name
  version                      = "12.0"
  administrator_login          = var.admin-login
  administrator_login_password = var.admin-pass

}

resource "azurerm_mssql_database" "sql-db" {
  name         = var.sql-db-name
  server_id    = azurerm_mssql_server.sql-paas.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = var.sql-size-gb
  depends_on   = [azurerm_mssql_server.sql-paas]
}


resource "azurerm_private_endpoint" "pvt-ep-sql" {
  name                = "${var.sql-name}-pvt-ep"
  location            = var.location
  resource_group_name = var.rg-name
  subnet_id           = var.db-subnet-id
  private_service_connection {
    name                           = "${var.sql-name}-connec"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.sql-paas.id
    subresource_names              = ["sqlserver"]
  }
  depends_on = [azurerm_mssql_server.sql-paas]
}