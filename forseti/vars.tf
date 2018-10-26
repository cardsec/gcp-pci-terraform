provider "google" {
  region = "${var.region}"
}

variable "project_name" {
  default = "pci-dss-demo"
}

variable "region" {
  default = "us-central1"
}

variable "region_zone" {
  default = "us-central1-f"
}

variable "org_id" {
  description = "The ID of the Google Cloud Organization."
  default     = "870160332389"
}

variable "billing_account" {
  description = "The ID of the associated billing account (optional)."
#  default     = "01A865-FEFFAE-D9C1D9"
  default     = "01D7D9-872112-4023F1"
}


variable "credentials_file_path" {
  description = "Location of the credentials to use."
  default     = "/Users/anners/.config/gcloud/anners-demo-terraform-admin.json"
}
