resource "azurecaf_name" "autoscale" {
  name          = var.stack
  resource_type = "azurerm_monitor_autoscale_setting"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "autoscale"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}
