/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
provider "google" {
  region = "${var.region}"
}

variable "project_name" {
  default = "dev-pci-dss-demo"
}

variable "region" {
  default = "us-central1"
}

variable "region_zone" {
  default = "us-central1-f"
}

variable "org_id" {
  description = "The ID of the Google Cloud Organization."
  default     = ""
}

variable "billing_account" {
  description = "The ID of the associated billing account (optional)."
  default     = ""
}


variable "credentials_file_path" {
  description = "Location of the credentials to use."
  default     = ""
}
