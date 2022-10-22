terraform {
  required_version = ">=0.12"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "location" {
  default = "eastus"
}

variable "prefix" {
  default = "appdemo"
}

variable "github_pat" {
    description = "access token" 
}

# Generate a random integer to create a globally unique name
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}


# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.location

  tags = {
    "environment" = "demo"
  }
}


resource "azurerm_service_plan" "asp" {
  name                = "${var.prefix}-asp-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "F1"

  tags = {
    "environment" = "demo"
  }
}

# need to whitelist IP address of app_svc in MongoDB Atlas Instance for access
resource "azurerm_linux_web_app" "app_svc" {
  name                = "${var.prefix}-app-svc-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp.id
  https_only          = true


  site_config {
    minimum_tls_version = "1.2"
    always_on           = false

    application_stack {
      docker_image     = "blastomussa/soap-recipe-api"
      docker_image_tag = "latest"
    }

  }

  tags = {
    "environment" = "demo"
  }
}


output "url" {
  value = azurerm_linux_web_app.app_svc.default_hostname
}