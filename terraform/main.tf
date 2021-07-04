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

variable "contact_name" {
  description = "Full name of the contact person for APIM and SSL certifiate."
  type        = string
}

variable "contact_email" {
  description = "Email address for APIM and SSL renewal notifications."
  type        = string
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = var.base_name
  location = var.location
}