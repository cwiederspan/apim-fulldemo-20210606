locals {
  app_gateway_name               = "${var.base_name}-appgw"
  gateway_ip_config_name         = "${local.app_gateway_name}-gwip"
  backend_address_pool_name      = "${local.app_gateway_name}-beap"
  frontend_port_name             = "${local.app_gateway_name}-feport"
  frontend_ip_configuration_name = "${local.app_gateway_name}-feip"
  http_setting_name              = "${local.app_gateway_name}-be-htst"
  listener_name                  = "${local.app_gateway_name}-httplstn"
  request_routing_rule_name      = "${local.app_gateway_name}-rqrt"
  probe_name                     = "${local.app_gateway_name}-probe"
}

resource "azurerm_public_ip" "ip" {
  name                = "${var.base_name}-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  domain_name_label   = local.app_gateway_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_user_assigned_identity" "appgwmsi" {
  name                = "${var.base_name}-appgw"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_application_gateway" "gateway" {
  name                = local.app_gateway_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.appgwmsi.id
    ]
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_config_name
    subnet_id = azurerm_subnet.ingress.id
  }

  ssl_certificate {
    name                = "${var.base_name}-ssl"
    key_vault_secret_id = azurerm_key_vault_certificate.cert.secret_id
  }

  trusted_root_certificate {
    name = "${var.base_name}-trc"
    data = azurerm_key_vault_certificate.cert.certificate_data_base64
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.ip.id
  }

  #   frontend_port {
  #     name = "${local.frontend_port_name}-http"
  #     port = 80
  #   }

  frontend_port {
    name = "${local.frontend_port_name}-https"
    port = 443
  }

  backend_address_pool {
    name = "${local.backend_address_pool_name}-apim"
    ip_addresses = [
      azurerm_api_management.apim.private_ip_addresses[0]
    ]
  }

  http_listener {
    name                           = "${local.listener_name}-proxy"
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = "${local.frontend_port_name}-https"
    protocol                       = "https"
    ssl_certificate_name           = "${var.base_name}-ssl"
    host_names                     = [local.apim_proxy_dns_name]
    require_sni                    = true
  }

  http_listener {
    name                           = "${local.listener_name}-devportal"
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = "${local.frontend_port_name}-https"
    protocol                       = "https"
    ssl_certificate_name           = "${var.base_name}-ssl"
    host_names                     = [local.apim_devportal_dns_name]
    require_sni                    = true
  }

  backend_http_settings {
    name                           = "${local.http_setting_name}-proxy"
    cookie_based_affinity          = "Disabled"
    port                           = 443
    protocol                       = "https"
    path                           = "/"
    request_timeout                = 180
    trusted_root_certificate_names = ["${var.base_name}-trc"]
    probe_name                     = "${local.probe_name}-proxy"
    host_name                      = local.apim_proxy_dns_name
  }

  backend_http_settings {
    name                           = "${local.http_setting_name}-devportal"
    cookie_based_affinity          = "Disabled"
    port                           = 443
    protocol                       = "https"
    path                           = "/"
    request_timeout                = 180
    trusted_root_certificate_names = ["${var.base_name}-trc"]
    probe_name                     = "${local.probe_name}-devportal"
    host_name                      = local.apim_devportal_dns_name
  }

  probe {
    name                = "${local.probe_name}-proxy"
    protocol            = "https"
    path                = "/status-0123456789abcdef"
    interval            = 30
    timeout             = 120
    unhealthy_threshold = 8
    host                = local.apim_proxy_dns_name
  }

  probe {
    name                = "${local.probe_name}-devportal"
    protocol            = "https"
    path                = "/internal-status-0123456789abcdef"
    interval            = 60
    timeout             = 300
    unhealthy_threshold = 8
    host                = local.apim_devportal_dns_name
  }

  request_routing_rule {
    name      = "${local.request_routing_rule_name}-proxy"
    rule_type = "Basic"

    backend_address_pool_name  = "${local.backend_address_pool_name}-apim"
    http_listener_name         = "${local.listener_name}-proxy"
    backend_http_settings_name = "${local.http_setting_name}-proxy"
  }

  request_routing_rule {
    name      = "${local.request_routing_rule_name}-devportal"
    rule_type = "Basic"

    backend_address_pool_name  = "${local.backend_address_pool_name}-apim"
    http_listener_name         = "${local.listener_name}-devportal"
    backend_http_settings_name = "${local.http_setting_name}-devportal"
  }
}
