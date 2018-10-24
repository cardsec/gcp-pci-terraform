terraform {
 backend "gcs" {
   bucket  = "pci-demo-terraform"
   prefix  = "terraform/state"
   project = "pci-demo-terraform"
 }
}
