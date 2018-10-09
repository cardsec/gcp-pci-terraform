# PCI deployable architecture on GCP with Terraform
These terraform files build out an example PCI architecture in GCP. These have not been certified by a PCI DSS auditor.

## Usage
- [TF user setup](readme.txt)
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

## Requirements
### Installation Dependencies
- [Terraform](https://www.terraform.io/downloads.html)

## Architecture
[diagrams/PCIterraform.png]
- PCI Shared VPC
  * VPC peering with Non-PCI Shared VPC
  * PCI Firewall allows inbound ssh
  * Cloud Armor
    * security policy: only allow traffic from a range of ip addresses
  * In Scope CDE Project
    * 1 GCE instance is deployed which has access to Cloud SQL in the Out of Scope Project
    * Attach Cloud Armor policy to GCE instance
    * DLP API is enabled
- Non-PCI Shared VPC
  * VPC peering with PCI Shared VPC
  * Non-PCI Firewall allows inbound ssh and http
  * Out of Scope Project
    * 1 GCE instance is deployed which has access to Cloud SQL in the Out of Scope Project
    * Cloud SQL (mysql)
  * Stackdriver Project
    * GCS bucket
    * Project Level sink with a filter PCI web instance
  * Forseti Project
    * Creates Forseti service account and permissions
    * Installs Forseti

## TODO
- Add TF project & service account set-up to this doc
- Deploy a real application, not just GCE instances
- Define IAM users / groups / roles
- Need to tie everything together - alerts, monitoring, etc
- Verify logs are being written to the stackdriver bucket
- delete forseti service account once forseti has been set-up
- clean up IAM permissions for TF service account they are probably too permissive
- Configure Forseti
- Document Forseti install steps - [Module GitHub](https://github.com/terraform-google-modules/terraform-google-forseti)
