terraform {
  required_version = ">= 0.15"
  
  backend "azurerm" {
    environment = "public"
  }

  required_providers {
    azurerm = {
      version = "~> 2.62"
    }

    acme = {
      source  = "vancluever/acme"
      version = "~> 2.4"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.1.0"
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