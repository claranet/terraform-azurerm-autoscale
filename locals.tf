locals {
  resource_group_name = coalesce(var.resource_group_name, element(split("/", var.target_resource_id), 4))
}
