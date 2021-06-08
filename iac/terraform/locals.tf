locals {
  apim_proxy_dns_name      = "api.${var.root_dns_name}"
  apim_management_dns_name = "management.${var.root_dns_name}"
  apim_devportal_dns_name  = "developer.${var.root_dns_name}"
  apim_scm_dns_name        = "git.${var.root_dns_name}"
}