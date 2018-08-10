

provider "google" {
 region = "${var.region}"
}
variable "project_name" {}

variable "region" {
  default = "us-central1"
}

variable "region_zone" {
  default = "us-central1-f"
}

variable "org_id" {
  description = "The ID of the Google Cloud Organization."
  default = "822294951214"
}

variable "billing_account" {
  description = "The ID of the associated billing account (optional)."
  default = "01A4FD-250E6F-FF9F5C"
}

variable "credentials_file_path" {
  description = "Location of the credentials to use."
  default     = "/Users/anners/.config/gcloud/terraform-admin.json"
}
