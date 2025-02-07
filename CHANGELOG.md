## 8.0.0 (2025-02-07)

### ⚠ BREAKING CHANGES

* **AZ-1088:** AzureRM Provider v4+ and OpenTofu 1.8+

### Features

* **AZ-1088:** module v8 structure and updates 1be177a
* **AZ-1088:** refactor variable, fix example 46c2ccd

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.8.3 327bafe
* **deps:** update dependency opentofu to v1.8.4 a126fa7
* **deps:** update dependency opentofu to v1.8.6 30adffa
* **deps:** update dependency opentofu to v1.8.7 87311b2
* **deps:** update dependency opentofu to v1.8.8 00ad86c
* **deps:** update dependency opentofu to v1.9.0 a4089ec
* **deps:** update dependency pre-commit to v4 0c95a91
* **deps:** update dependency pre-commit to v4.0.1 2985ba5
* **deps:** update dependency pre-commit to v4.1.0 5d34ab4
* **deps:** update dependency tflint to v0.54.0 2dfc097
* **deps:** update dependency tflint to v0.55.0 36612d4
* **deps:** update dependency tflint to v0.55.1 a64d018
* **deps:** update dependency trivy to v0.56.1 adc1704
* **deps:** update dependency trivy to v0.56.2 3d85c33
* **deps:** update dependency trivy to v0.57.1 05e3d7f
* **deps:** update dependency trivy to v0.58.0 17f30b9
* **deps:** update dependency trivy to v0.58.1 0151a8e
* **deps:** update dependency trivy to v0.58.2 a0b736f
* **deps:** update dependency trivy to v0.59.0 a7303b6
* **deps:** update dependency trivy to v0.59.1 fc12884
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.19.0 94d7f27
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.20.0 b4d3445
* **deps:** update pre-commit hook pre-commit/pre-commit-hooks to v5 a36fe06
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.1.0 cc86886
* **deps:** update tools e474a14
* suggestions af6fff0
* update examples structure d35f2e1
* update Github templates 92e3480
* update tflint config for v0.55.0 3f6c9bc

## 7.1.0 (2024-10-07)

### Features

* use Claranet "azurecaf" provider 9880af0

### Documentation

* update README badge to use OpenTofu registry 2492655
* update README with `terraform-docs` v0.19.0 3637141

### Miscellaneous Chores

* **deps:** update dependency claranet/diagnostic-settings/azurerm to v7 b5b02f1
* prepare for new examples structure 027b79f

## 7.0.2 (2024-09-27)

### Bug Fixes

* **AZ-1463:** remove default autoscale_profile local e79e65d

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.8.2 14bd783
* **deps:** update dependency terraform-docs to v0.19.0 f140103
* **deps:** update dependency trivy to v0.55.0 e4abf73
* **deps:** update dependency trivy to v0.55.1 490246a
* **deps:** update dependency trivy to v0.55.2 870708c
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.18.0 4c498b3
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.2 d1cd028
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.3 87e66c3
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.95.0 a94eb93
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.0 750147d
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.1 9950c78

## 7.0.1 (2024-09-03)

### Bug Fixes

* remove lookup to fix lint 31feb97

### Continuous Integration

* **AZ-1391:** enable semantic-release [skip ci] 9350764
* **AZ-1391:** update semantic-release config [skip ci] e6de215

### Miscellaneous Chores

* **deps:** add renovate.json 0c4ccd9
* **deps:** enable automerge on renovate 92b946c
* **deps:** update dependency opentofu to v1.7.0 64c87a1
* **deps:** update dependency opentofu to v1.7.1 fcc9438
* **deps:** update dependency opentofu to v1.7.2 1f746e9
* **deps:** update dependency opentofu to v1.7.3 bdee0c5
* **deps:** update dependency opentofu to v1.8.0 8f3fe95
* **deps:** update dependency opentofu to v1.8.1 3835cfb
* **deps:** update dependency pre-commit to v3.7.1 fbacba7
* **deps:** update dependency pre-commit to v3.8.0 529392d
* **deps:** update dependency terraform-docs to v0.18.0 492c54a
* **deps:** update dependency tflint to v0.51.0 bf8c4f9
* **deps:** update dependency tflint to v0.51.1 b86bab3
* **deps:** update dependency tflint to v0.51.2 6b70323
* **deps:** update dependency tflint to v0.52.0 213c1e6
* **deps:** update dependency tflint to v0.53.0 49bbe1f
* **deps:** update dependency trivy to v0.50.2 d105a29
* **deps:** update dependency trivy to v0.50.4 fc166ca
* **deps:** update dependency trivy to v0.51.0 61fc62b
* **deps:** update dependency trivy to v0.51.1 a646e6a
* **deps:** update dependency trivy to v0.51.2 128de6d
* **deps:** update dependency trivy to v0.51.3 6d84515
* **deps:** update dependency trivy to v0.51.4 63bee2f
* **deps:** update dependency trivy to v0.52.0 c499c50
* **deps:** update dependency trivy to v0.52.1 fe181b8
* **deps:** update dependency trivy to v0.52.2 90fff96
* **deps:** update dependency trivy to v0.53.0 d6b293e
* **deps:** update dependency trivy to v0.54.1 46d0330
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.17.0 fe7f5b0
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.0 5c2a1ae
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.1 e7500d8
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.2 43b3b0e
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.1 933a0a0
* **deps:** update renovate.json 2477b18
* **pre-commit:** update commitlint hook a9d893f
* **release:** remove legacy `VERSION` file 7b5fccc

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
