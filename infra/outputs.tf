output "web_app_name" {
  value = "azure_linux_web_app.alwa.default_hostname"
}

output "sql_server_name" {
  value = "azurerm_mssql_server.ams.name"
}

output "web_ip_address" {
  value = "azure_linux_web_app.alwa.default_site_hostname"
}
