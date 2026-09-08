terraform {
  required_version = ">= 1.16.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    use_cli              = true
    use_azuread_auth     = true
    storage_account_name = "sttfstatejaved31625"
    container_name       = "tfstate"
    key                  = "azure-enterprise-lab.tfstate"
  }
}

provider "azurerm" {
  features {}
}