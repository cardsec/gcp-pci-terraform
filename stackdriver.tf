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
resource "google_project" "stackdriver" {
  name            = "stackdriver-${var.project_name}"
  project_id      = "stackdriver-${random_id.pci_id.hex}"
  billing_account = "${var.billing_account}"
  org_id          = "${var.org_id}"
}

resource "google_project_services" "stackdriver" {
  project = "${google_project.stackdriver.project_id}"

  services = [
    "compute.googleapis.com",
    "oslogin.googleapis.com",
  ]
}

resource "google_compute_shared_vpc_service_project" "stackdriver" {
  host_project    = "${google_project.mgmt_shared.project_id}"
  service_project = "${google_project.stackdriver.project_id}"

  depends_on = ["google_compute_shared_vpc_host_project.mgmt_shared",
    "google_project_services.stackdriver",
  ]
}

resource "google_storage_bucket" "log_bucket" {
  name    = "logging-bucket-${var.project_name}-${random_id.pci_id.hex}"
  project = "${google_project.stackdriver.project_id}"
}

resource "google_logging_project_sink" "instance_sink" {
  name                   = "instance-sink"
  destination            = "storage.googleapis.com/${google_storage_bucket.log_bucket.name}"
  filter                 = "resource.type = gce_instance AND resource.labels.instance_id = \"${google_compute_instance.pci_web.instance_id}\""
  project                = "${google_project.stackdriver.project_id}"
  unique_writer_identity = true
}

# Because our sink uses a unique_writer, we must grant that writer access to the bucket.
resource "google_project_iam_binding" "log_writer" {
  role    = "roles/storage.objectCreator"
  project = "${google_project.stackdriver.project_id}"

  members = [
    "${google_logging_project_sink.instance_sink.writer_identity}",
  ]

  depends_on = ["google_logging_project_sink.instance_sink"]
}
