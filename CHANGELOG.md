# v7.0.0 - 2024-01-26

Breaking
  * AZ-1340: Rework module implementation, more compatible with Service Plan
  * AZ-1340: Terraform 1.3 minimum version required, compatible with OpenTofu 1.6+

# v6.1.0 - 2023-12-01

Fixed
  * AZ-1288: Remove `retention_days` parameters, it must be handled at destination level now. (for reference: [Provider issue](https://github.com/hashicorp/terraform-provider-azurerm/issues/23051))

# v6.0.0 - 2022-11-25

Breaking
  * AZ-839: Require Terraform 1.1+ and AzureRM provider `v3.22+`

Changed
  * AZ-908: Use the new data source for CAF naming (instead of resource)

# v5.1.0 - 2022-04-15

Added
  * AZ-615: Add an option to enable or disable default tags

# v5.0.0 - 2022-02-03

Breaking
  * AZ-515: Option to use Azure CAF naming provider to name resources
  * AZ-515: Require Terraform 0.13+

Fixed
  * AZ-589: Avoid plan drift when specifying Diagnostic Settings categories

# v4.0.0 - 2021-10-07

Added
  * AZ-375: First release
