module "traffic-flow" {
  source         = "./modules/traffic-flow"
  fw-policy-id   = module.traffic.fw-policy-id
  location       = azurerm_resource_group.myrg.location
  rg-name        = azurerm_resource_group.myrg.name
  fw-id          = module.traffic.fw-id
  group-name     = "to-app-gw"
  group-priority = 175
  NAT-name       = "nat-to-app-gw"
  rule-priority  = 180
  nat-rules = [
    {
      name                = "rule-fw-apgw"
      protocols           = ["TCP"]
      source_addresses    = ["*"]
      destination_address = module.traffic.fw-p-ip
      destination_ports   = ["80"]
      translated_address  = module.traffic.ap-gw-p-ip
      translated_port     = "80"
    }
  ]
  rt-table-name = "${var.type}-route-table-tf"
  routes = {
    "to-internet" = {
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = module.traffic.fw-pvt-ip
    }
  }
  rt-assoc = {
    "web-subnet-assoc" = {
      subnet_id      = module.networking.subnet-ids["web"]
      route_table_id = module.traffic-flow.route-table-id
    }
    "backend-subnet-assoc" = {
      subnet_id      = module.networking.subnet-ids["backend"]
      route_table_id = module.traffic-flow.route-table-id
    }
  }
  depends_on = [module.traffic]
}