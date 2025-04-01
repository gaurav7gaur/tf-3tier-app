module "compute" {
  source   = "./modules/compute"
  rg-name  = azurerm_resource_group.myrg.name
  location = azurerm_resource_group.myrg.location

  app-service-plan-name = "${var.type}-service-plan"

  web-app-service-name = "${var.type}-web-app"
  back-app-name        = "${var.type}-backend-app"
  back-app-settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
    DB_USER     = var.sql-admin-user       # Replace with your SQL admin username
    DB_PASSWORD = var.sql-pass       # Replace with your SQL admin password
    DB_SERVER   = module.compute.sql-server-fqdn # Replace with your SQL server name
    DB_NAME     = "tryingoncemore"            # Replace with your database name

  }
  web-app-settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
    BACKEND_API_URL = "https://${module.compute.back-app-default-hostname}"
  }

  app-service-plan-sku = "P0v3"
  app-os               = "Linux"

  web-subnet-id     = module.networking.subnet-ids["web"]
  backend-subnet-id = module.networking.subnet-ids["backend"]

  sql-name     = "checkingoncemore01"
  admin-login  = var.sql-admin-user
  admin-pass   = var.sql-pass
  sql-db-name  = "tryingoncemore"
  sql-size-gb  = 2
  db-subnet-id = module.networking.subnet-ids["db"]


  depends_on = [module.networking]
}