# API Token for SWA
output "api_token" {
  value = azurerm_static_site.swa.api_key
}

output "name_servers" {
  value = azurerm_dns_zone.swa.name_servers
}