resource "azurerm_firewall_policy_rule_collection_group" "rule-collection0-group" {
  name = var.group-name
  firewall_policy_id = var.fw-policy-id
  priority = var.group-priority

  nat_rule_collection {
    name = var.NAT-name
    priority = var.rule-priority
    action = "Dnat"
    dynamic rule {
      for_each = var.nat-rules
      content {
        name                   = rule.value.name
        protocols              = rule.value.protocols
        source_addresses       = rule.value.source_addresses
        destination_ports      = rule.value.destination_ports
        destination_address    = rule.value.destination_address
        translated_address     = rule.value.translated_address
        translated_port        = rule.value.translated_port
      }
    }
  }
}

resource "azurerm_route_table" "rt-table" {
  name = var.rt-table-name
  location = var.location
  resource_group_name = var.rg-name
}

resource "azurerm_route" "route" {
  for_each = var.routes
  name = each.key
  resource_group_name = var.rg-name
  route_table_name = azurerm_route_table.rt-table.name
  address_prefix = each.value.address_prefix
  next_hop_type = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address
  depends_on = [ azurerm_route_table.rt-table ]
}

resource "azurerm_subnet_route_table_association" "route-assoc" {
  for_each = var.rt-assoc
  subnet_id = each.value.subnet_id
  route_table_id = each.value.route_table_id
}