output "resource" {
  description = "Azure Autoscale setting resource object."
  value       = azurerm_monitor_autoscale_setting.main
}

output "module_diagnostics" {
  description = "Diagnostics Settings module output."
  value       = module.diagnostics
}

output "id" {
  description = "ID of the Azure Autoscale setting."
  value       = azurerm_monitor_autoscale_setting.main.id
}

output "name" {
  description = "Name of the Azure Autoscale setting."
  value       = local.name
}
