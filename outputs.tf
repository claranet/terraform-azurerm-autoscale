output "autoscale_setting_id" {
  value       = azurerm_monitor_autoscale_setting.autoscale.id
  description = "Azure Autoscale setting ID"
}

output "autoscale_setting_name" {
  value       = local.autoscale_setting_name
  description = "Azure Autoscale setting name"
}

output "autoscale_setting_profile" {
  value       = local.autoscale_profile
  description = "Azure Autoscale setting profile"
}
