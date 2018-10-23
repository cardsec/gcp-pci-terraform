terraform {
 backend "gcs" {
   bucket  = "pci-demo-terraform-admin"
   prefix  = "terraform/state"
   project = "pci-demo-terraform-admin"
 }
}
