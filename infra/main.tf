terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "bee5e7ba-32c2-4108-8295-248b1dd4f194"
  features {}
}

resource "azurerm_resource_group" "arg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_resource_group.arg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "alwa" {
  name                = var.web_app_name
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_service_plan.asp.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }
  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Server=tcp:${azurerm_mssql_server.ams.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.amd.name};User ID=${azurerm_mssql_server.ams.administrator_login};Password=${azurerm_mssql_server.ams.administrator_login_password};Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}

resource "azurerm_mssql_server" "ams" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.arg.name
  location                     = azurerm_resource_group.arg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
  minimum_tls_version          = "1.2"
}

resource "azurerm_mssql_database" "amd" {
  name                 = var.sql_database_name
  server_id            = azurerm_mssql_server.ams.id
  collation            = "SQL_Latin1_General_CP1_CI_AS"
  license_type         = "LicenseIncluded"
  max_size_gb          = 2
  sku_name             = "S0"
  enclave_type         = "VBS"
  zone_redundant       = false
  storage_account_type = "Local"

  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_mssql_firewall_rule" "amfr" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.ams.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_app_service_source_control" "aassc" {
  app_id                 = azurerm_linux_web_app.alwa.id
  repo_url               = var.github_repo_url
  branch                 = "main"
  use_manual_integration = true
}