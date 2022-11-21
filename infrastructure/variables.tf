# Variables that we will need

# Azure region
variable "region" {
  type        = string
  description = "(Required) Region to use for your SWA deployment. Currently supported regions are westus2, centralus, eastus2, westeurope, eastasia, eastasiastage"

  validation {
    condition     = contains(["westus2", "centralus", "eastus2", "westeurope", "eastasia", "eastasiastage"], var.region)
    error_message = "You must specify a supported region. Currently supported regions are westus2, centralus, eastus2, westeurope, eastasia, eastasiastage."
  }
}

# Common tags
variable "common_tags" {
  type        = map(string)
  description = "(Optional) Map of tags to apply to the resources in the deployment. Defaults to none."
  default     = {}
}

# SWA Tier (default to Free)
variable "static_web_app_sku" {
  type        = string
  description = "(Optional) Sku tier to use for the SWA. Defaults to Free."
  default     = "Free"
}

# Name of website
variable "website_name" {
  type        = string
  description = "(Required) Name of website you plan to deploy. E.g. www.10bitpodcast.com"
}

# Custom name for domain
variable "custom_domain_name" {
  type        = string
  description = "(Required) The domain you'll be using for the SWA"
}