# Generate a private key for LetsEncrypt account
resource "tls_private_key" "reg_private_key" {
  algorithm = local.ssl_key_type
}

# Create an LetsEncrypt registration
resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.reg_private_key.private_key_pem
  email_address   = var.contact_email
}

# Generate LetsEncrypt certificates using Azure DNS
resource "acme_certificate" "ssl" {
  account_key_pem = acme_registration.reg.account_key_pem
  common_name     = var.root_dns_name
  key_type        = local.ssl_key_size

  subject_alternative_names = [
    local.apim_proxy_dns_name,
    local.apim_management_dns_name,
    local.apim_devportal_dns_name,
    local.apim_scm_dns_name
  ]

  min_days_remaining = 60

  dns_challenge {
    provider = "azure"

    config = {
      AZURE_RESOURCE_GROUP = azurerm_resource_group.rg.name

      # AZURE_TENANT_ID       = data.azurerm_client_config.current.tenant_id
      # AZURE_SUBSCRIPTION_ID = data.azurerm_client_config.current.subscription_id
      # AZURE_CLIENT_ID       = data.azurerm_client_config.current.client_id #var.az_sp_app_id
      # AZURE_CLIENT_SECRET   = var.az_sp_app_secret
    }
  }
}

resource "azurerm_key_vault_certificate" "cert" {
  name         = "${var.base_name}-cert"
  key_vault_id = azurerm_key_vault.kv.id

  certificate {
    contents = acme_certificate.ssl.certificate_p12
    password = ""
  }

  certificate_policy {
    issuer_parameters {
      name = "Unknown"
    }

    key_properties {
      exportable = true
      reuse_key  = true
      key_size   = local.ssl_key_size
      key_type   = local.ssl_key_type
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
}