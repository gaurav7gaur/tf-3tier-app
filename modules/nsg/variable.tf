variable "location" {

}
variable "rg-name" {

}
variable "nsgs" {
  description = "map of NSGs & their rules. Key is the name of NSG, and value is a list of rules"
  type = map(list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string

  })))
}

variable "nsg-assoc" {
  description = "map of nsg-association. Key is NSG name, and value is an object with subnet-id"
  type = map(object({
    subnet-id = string
  }))
}