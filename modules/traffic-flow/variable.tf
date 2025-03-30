variable "fw-policy-id" {

}
variable "location" {

}
variable "rg-name" {

}
variable "fw-id" {

}
variable "group-name" {

}
variable "group-priority" {
  type = number
}
variable "NAT-name" {

}
variable "rule-priority" {
  type = number
}
variable "nat-rules" {
  description = "map of rules. Key is the name of rule, and value is the list of rules"
  type = list(object({
    name                = string
    protocols           = list(string)
    source_addresses    = list(string)
    destination_address = string
    destination_ports   = list(string)
    translated_address  = string
    translated_port     = string
  }))
}

variable "rt-table-name" {

}
variable "routes" {
  description = "map of route definitions"
  type = map(object({
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  }))
}
variable "rt-assoc" {
  type = map(object({
    subnet_id      = string
    route_table_id = string
  }))
}