variable "client_name" {
  description = "Client name/account used in naming."
  type        = string
}

variable "environment" {
  description = "Project environment."
  type        = string
}

variable "stack" {
  description = "Project stack name."
  type        = string
}

variable "azure_region" {
  description = "Azure region to use."
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key to authorize on VMSS's instances."
  type        = string
}
