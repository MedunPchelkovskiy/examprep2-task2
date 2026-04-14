variable "resource_group_name" {
  description = "The name of RG"
  type        = string
}

variable "location" {
  description = "The Azure region resource are created"
  type        = string
}

variable "app_service_plan" {
  description = "The name of app service plan"
  type        = string
}

variable "web_app_name" {
  description = "The name of deployed app"
  type        = string
}

variable "sql_server_name" {
  description = "The name of SQL server"
  type        = string
}

variable "sql_database_name" {
  description = "The name of application database"
  type        = string
}

variable "sql_admin_username" {
  description = "Admin username of SQL server"
  type        = string
}

variable "sql_admin_password" {
  description = "Admin password for SQL server"
  type        = string
  sensitive   = true
}

variable "firewall_rule_name" {
  description = "The name of firewall rule"
  type        = string
}

variable "github_repo_url" {
  description = "The URL of the repo we deploy from"
  type        = string
}