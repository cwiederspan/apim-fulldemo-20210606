locals {
  gateway_dns_prefix       = "api"
  management_dns_prefix    = "management"
  devportal_dns_prefix     = "developer"
  scm_dns_prefix           = "git"

  apim_gateway_dns_name    = "${local.gateway_dns_prefix}.${var.root_dns_name}"
  apim_management_dns_name = "${local.management_dns_prefix}.${var.root_dns_name}"
  apim_devportal_dns_name  = "${local.devportal_dns_prefix}.${var.root_dns_name}"
  apim_scm_dns_name        = "${local.scm_dns_prefix}.${var.root_dns_name}"

  ssl_key_size             = 2048
  ssl_key_type             = "RSA"
}