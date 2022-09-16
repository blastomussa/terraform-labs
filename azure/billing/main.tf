terraform {
  required_version = ">= 1.2"
  required_providers {
    azurerm = {
      version = "~> 3.22.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {}

resource "azurerm_consumption_budget_subscription" "alert" {
  name            = "Project-Budget-Alert"
  subscription_id = data.azurerm_subscription.current.id

  amount     = 20
  time_grain = "Monthly"

  time_period {
    start_date = "2022-09-01T00:00:00Z"
    end_date   = "2022-11-01T00:00:00Z"
  }

  notification {
    enabled   = true
    threshold = 90.0
    operator  = "EqualTo"

    contact_emails = [
      "jccourtn@gmail.com"
    ]
  }
}

