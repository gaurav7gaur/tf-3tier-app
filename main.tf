terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.16.0"
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

resource "azurerm_resource_group" "myrg" {
  name     = "${var.type}-rg"
  location = "northeurope"
}
