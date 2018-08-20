terraform {
 backend "gcs" {
   bucket  = "gcp-pci-terraform-admin"
   path    = "/terraform.tfstate"
   project = "gcp-pci-terraform-admin"
 }
}
