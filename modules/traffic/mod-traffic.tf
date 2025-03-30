resource "azurerm_public_ip" "ag-pip" {
  name = "${var.ag-name}-pip"
  location = var.location
  resource_group_name = var.rg-name
  allocation_method = "Static"
}

resource "azurerm_public_ip" "fw-pip" {
  name = "${var.firewall-name}-pip"
  location = var.location
  resource_group_name = var.rg-name
  allocation_method = "Static"
}

locals {
  backend_address_pool_name      = "${var.ag-name}-beap"
  frontend_port_name             = "${var.ag-name}-feport"
  frontend_ip_configuration_name = "${var.ag-name}-feip"
  http_setting_name              = "${var.ag-name}-be-htst"
  listener_name                  = "${var.ag-name}-httplstn"
  request_routing_rule_name      = "${var.ag-name}-rqrt"
  redirect_configuration_name    = "${var.ag-name}-rdrcfg"
}

resource "azurerm_application_gateway" "ag" {
  name = var.ag-name
  location = var.location
  resource_group_name = var.rg-name
  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
    capacity = 1
  }
  gateway_ip_configuration {
    name = "gateway-ip-config"
    subnet_id = var.ag-subnet-id
  }
  frontend_port {
    name = local.frontend_port_name
    port = 80
  }
  frontend_ip_configuration {
    name = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.ag-pip.id
  }
  backend_address_pool {
    name = local.backend_address_pool_name
    fqdns = [var.web-app-hostname]
  }
  backend_http_settings {
    cookie_based_affinity = "Enabled"
    name = local.http_setting_name
    port = 80
    protocol = "Http"
    request_timeout = 60
  }
  http_listener {
    name = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name = local.frontend_port_name
    protocol = "Http"
  }
  request_routing_rule {
    name = local.request_routing_rule_name
    http_listener_name = local.listener_name
    rule_type = "Basic"
    backend_address_pool_name = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority = 9
  }
  waf_configuration {
    enabled = true
    firewall_mode = "Prevention"
    rule_set_type = "OWASP"
    rule_set_version = "3.0"
  }

  depends_on = [ azurerm_public_ip.ag-pip ]
}

resource "azurerm_firewall" "fw" {
  name = var.fw-name
  location = var.location
  resource_group_name = var.rg-name
  sku_name = "AZFW_VNet"
  sku_tier = "Standard"
  ip_configuration {
    name = "config"
    public_ip_address_id = azurerm_public_ip.fw-pip.id
    subnet_id = var.fw-subnet-id
  }
  depends_on = [ azurerm_public_ip.fw-pip ]
}
