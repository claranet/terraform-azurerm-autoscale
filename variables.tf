variable "client_name" {
  description = "Name of client"
  type        = string
}

variable "environment" {
  description = "Name of application's environnement"
  type        = string
}

variable "stack" {
  description = "Name of application stack"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the application ressource group, herited from infra module"
  type        = string
}

variable "location" {
  description = "Azure location for Key Vault."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "target_resource_id" {
  description = "ID of the resource to apply the autoscale setting to."
  type        = string
}

variable "autoscale_profile" {
  description = "One or more (up to 20) autoscale profile blocks."
  type        = any
  default     = null
}

variable "notification" {
  description = "Manage emailing and webhooks for sending notifications."
  type        = any
  default     = {}
}

variable "enable_autoscale" {
  description = "Specifies whether automatic scaling is enabled for the target resource."
  type        = bool
  default     = true
}

variable "default_autoscale_profile_maximum_capacity" {
  description = "Maximum capacity for the default profile of Autoscale."
  type        = number
  default     = 5
}
