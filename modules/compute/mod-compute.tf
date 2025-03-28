resource "azurerm_service_plan" "plan" {
  name = var.app-service-plan-name
  location = var.location
  resource_group_name = var.rg-name
  sku_name = var.app-service-plan-sku  //"B1"
  os_type = var.app-os //"Linux"
}

resource "azurerm_linux_web_app" "web-app" {
  name = var.web-app-service-name
  location = var.location
  resource_group_name = var.rg-name
  service_plan_id = azurerm_service_plan.plan.id
  site_config {
    always_on = true
  }
  app_settings = var.web-app-settings
  identity {
    type = "SystemAssigned"
  }
  virtual_network_subnet_id = var.web-subnet-id
}

resource "azurerm_linux_web_app" "back-app" {
  name = var.back-app-name
  location = var.location
  resource_group_name = var.rg-name
  service_plan_id = azurerm_service_plan.plan.id
  site_config {
    always_on = true
  }
  app_settings = var.back-app-settings
  identity {
    type = "SystemAssigned"
  }
  virtual_network_subnet_id = var.backend-subnet-id
}


/*
resource "azurerm_app_service" "web-app" {
  name = var.web-app-service-name
  location = var.location
  resource_group_name = var.rg-name
  app_service_plan_id = azurerm_service_plan.plan.id
  site_config {
    always_on = true
  }
  app_settings = var.web-app-settings
  identity {
    type = "SystemAssigned"
  }
}
*/