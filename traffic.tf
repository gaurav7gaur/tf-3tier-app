module "traffic" {
  source           = "./modules/traffic"
  rg-name          = azurerm_resource_group.myrg.name
  location         = azurerm_resource_group.myrg.location
  ag-name          = "${var.type}-AG"
  firewall-name    = "${var.type}-firewall"
  ag-subnet-id     = module.networking.subnet-ids["application-gateway"]
  web-app-hostname = module.compute.web-app-default-hostname
  depends_on       = [module.compute]
}
