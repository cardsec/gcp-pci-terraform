terraform {
 backend "gcs" {
   bucket  = "x-anners-terraform-admin"
   path    = "/terraform.tfstate"
   project = "x-anners-terraform-admin"
 }
}
