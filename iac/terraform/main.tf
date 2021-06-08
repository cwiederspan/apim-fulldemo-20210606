terraform {
  required_version = ">= 0.15"
  
  backend "azurerm" {
    environment = "public"
  }

  required_providers {
    azurerm = {
      version = "~> 2.62"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "base_name" {
  type        = string
  description = "A base for the naming scheme as part of prefix-base-suffix."
}

variable "location" {
  type        = string
  description = "The Azure region where the resources will be created."
}

variable "root_dns_name" {
  type        = string
  description = "The root domain name to be used for exposing the APIM site."
}

resource "azurerm_resource_group" "rg" {
  name     = var.base_name
  location = var.location
}

data "azurerm_client_config" "current" {}