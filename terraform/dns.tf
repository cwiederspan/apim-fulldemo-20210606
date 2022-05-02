resource "azurerm_dns_zone" "dns" {
  name                = var.root_dns_name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_dns_a_record" "gateway" {
  name                = local.gateway_dns_prefix
  zone_name           = azurerm_dns_zone.dns.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [ azurerm_public_ip.ip.ip_address ]
}

resource "azurerm_dns_a_record" "management" {
  name                = local.management_dns_prefix
  zone_name           = azurerm_dns_zone.dns.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [ azurerm_public_ip.ip.ip_address ]
}

resource "azurerm_dns_a_record" "devportal" {
  name                = local.devportal_dns_prefix
  zone_name           = azurerm_dns_zone.dns.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [ azurerm_public_ip.ip.ip_address ]
}

resource "azurerm_dns_a_record" "scm" {
  name                = local.scm_dns_prefix
  zone_name           = azurerm_dns_zone.dns.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [ azurerm_public_ip.ip.ip_address ]
}