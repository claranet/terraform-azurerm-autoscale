locals {
  name_prefix  = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""
  default_name = lower("${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}")

  autoscale_setting_name = coalesce(var.custom_autoscale_setting_name, "${local.default_name}-autoscale")
}
