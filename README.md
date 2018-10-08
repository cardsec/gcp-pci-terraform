# PCI deployable architecture on GCP with Terraform
These terraform files build out an example PCI architecture in GCP. These have not been certified by a PCI DSS auditor.

## Usage
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

## Requirements
### Installation Dependencies
- [Terraform](https://www.terraform.io/downloads.html)

## Architecture
- PCI Shared VPC
  * In Scope CDE Project
- Non-PCI Shared VPC
