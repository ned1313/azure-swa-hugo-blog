terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }

  cloud {
    organization = "mjftech"

    workspaces {
      name = "azure-swa-hugo-blog"
    }
  }
}