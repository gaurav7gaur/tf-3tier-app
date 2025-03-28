module "compute" {
  source                = "./modules/compute"

  depends_on = [ module.networking ]
  app-service-plan-name = "${var.type}-service-plan"
  rg-name               = azurerm_resource_group.myrg.name
  location              = azurerm_resource_group.myrg.location
  web-app-service-name  = "${var.type}-web-app"
  back-app-name = "${var.type}-backend-app"
  back-app-settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
  web-app-settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }
  app-service-plan-sku = "P0v3"
  app-os = "Linux"
  web-subnet-id = module.networking.subnet-ids["web"]
  backend-subnet-id = module.networking.subnet-ids["backend"]
  sql-name = "checkingoncemore01"
  admin-login = "sqladmin"
  admin-pass = "P@ssw0rd1234"
  sql-db-name = "tryingoncemore"
  sql-size-gb = 2
}