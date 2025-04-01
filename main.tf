terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.16.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "> 3.0" 
    }
  }
}

provider "azurerm" {
  features {

  }
  subscription_id = "c45824c3-575b-47b1-9819-836f137632cb"
}

variable "type" {
  default = "tf-gg"
}

variable "sql-admin-user" {
  default = "sqladmin"
  sensitive = true
}
variable "sql-pass" {
  default = "P@ssw0rd1234"
  sensitive = true
}

resource "azurerm_resource_group" "myrg" {
  name     = "${var.type}-rg"
  location = "northeurope"
}
