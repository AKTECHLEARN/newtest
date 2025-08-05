terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features = {}
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

# Authentication via GitHub Secrets
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}

# Folder where ZIP will be extracted
variable "unzipped_path" {
  default = "unzipped"
}

# Existing Storage Account and Container
variable "existing_storage_account_name" {
  default = "kusaltest"
}

variable "existing_container_name" {
  default = "mycontainer"
}

# Get list of files in unzipped folder
locals {
  files = fileset(var.unzipped_path, "**/*")
}

# Upload all files to the blob container
resource "azurerm_storage_blob" "uploads" {
  for_each = { for file in local.files : file => file }

  name                   = each.key
  source                 = "${var.unzipped_path}/${each.value}"
  storage_account_name   = var.existing_storage_account_name
  storage_container_name = var.existing_container_name
  type                   = "Block"
}
