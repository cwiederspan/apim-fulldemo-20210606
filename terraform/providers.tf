terraform {
  required_version = ">= 1.1"
  
  backend "azurerm" {
    environment = "public"
  }

  required_providers {
    azurerm = {
      version = "~> 3.4"
    }

    acme = {
      source  = "vancluever/acme"
      version = "~> 2.8"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.3.0"
    }
  }
}

provider "azurerm" {

  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

provider "tls" {

}