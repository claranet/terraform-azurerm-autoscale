locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  autoscale_setting_name = coalesce(var.custom_autoscale_setting_name, data.azurecaf_name.autoscale.result)
}
