terraform {
 backend "gcs" {
   bucket  = "pci-terraform-admin"
   path    = "/terraform.tfstate"
   project = "pci-terraform-admin"
 }
}
