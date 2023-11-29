# Provider block
provider "azurerm" {
  features {}
}

# Resources to deploy

locals {
  basename = replace(var.website_name, ".", "")
  # Figure out if this is an apex website or uses a hostname
  hostname             = var.website_name == var.custom_domain_name ? "@" : split(".", var.website_name)[0]
  storage_account_name = lower(local.basename)
}

# Azure resource group

resource "azurerm_resource_group" "swa" {
  name     = local.basename
  location = var.region
  tags     = var.common_tags
}

# Azure static web app

resource "azurerm_static_site" "swa" {
  name                = local.basename
  resource_group_name = azurerm_resource_group.swa.name
  location            = azurerm_resource_group.swa.location
  sku_tier            = var.static_web_app_sku
  tags                = var.common_tags
}

resource "azurerm_static_site_custom_domain" "txt" {
  static_site_id  = azurerm_static_site.swa.id
  domain_name     = var.website_name
  validation_type = "dns-txt-token"
}

# Azure DNS

data "azurerm_dns_zone" "swa" {
  name                = var.custom_domain_name
  resource_group_name = var.rg_dns
  #tags                = var.common_tags

}

resource "azurerm_dns_txt_record" "txt" {
  name                = local.hostname
  zone_name           = data.azurerm_dns_zone.swa.name
  resource_group_name = var.rg_dns
  ttl                 = 300
  record {
    # Conditional required due to issue https://github.com/hashicorp/terraform-provider-azurerm/issues/14750
    value = azurerm_static_site_custom_domain.txt.validation_token == "" ? "validated" : azurerm_static_site_custom_domain.txt.validation_token
  }
}

resource "azurerm_dns_a_record" "alias" {
  name                = local.hostname
  zone_name           = data.azurerm_dns_zone.swa.name
  resource_group_name = var.rg_dns
  ttl                 = 300
  target_resource_id  = azurerm_static_site.swa.id
}