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
resource "google_project" "logging" {
  name            = "logging-${var.project_name}"
  project_id      = "logging-${random_id.pci_id.hex}"
  billing_account = "${var.billing_account}"
  org_id          = "${var.org_id}"
}

resource "google_project_services" "logging" {
  project = "${google_project.logging.project_id}"

  services = [
    "compute.googleapis.com",
    "oslogin.googleapis.com",
    "pubsub.googleapis.com"
  ]
}


resource "google_storage_bucket" "log_bucket" {
  name    = "logging-bucket-${var.project_name}-${random_id.pci_id.hex}"
  project = "${google_project.logging.project_id}"
}

resource "google_pubsub_topic" "pci_instance_activity" {
  name = "pci-instance-activity"
  project = "${google_project.logging.project_id}"
}
