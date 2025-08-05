terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.7.0"
}

provider "azurerm" {
  features = {}
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}

# Path to unzipped folder
variable "unzipped_path" {
  default = "unzipped"
}

# Existing Azure resources
variable "existing_storage_account_name" {
  default = "kusaltest"
}

variable "existing_container_name" {
  default = "mycontainer"
}

locals {
  files = fileset(var.unzipped_path, "**/*")
}

resource "azurerm_storage_blob" "uploads" {
  for_each = { for f in local.files : f => f }

  name                   = each.key
  source                 = "${var.unzipped_path}/${each.value}"
  storage_account_name   = var.existing_storage_account_name
  storage_container_name = var.existing_container_name
  type                   = "Block"
}
