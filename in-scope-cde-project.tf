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
# PCI application project
resource "random_id" "cde_id" {
  byte_length = 8
}

resource "google_project" "in_scope_cde" {
  name            = "in-scope-cde-${var.project_name}"
  project_id      = "in-scope-cde-${random_id.cde_id.hex}"
  billing_account = "${var.billing_account}"
  org_id          = "${var.org_id}"
}

resource "google_project_services" "in_scope_cde" {
  project = "${google_project.in_scope_cde.project_id}"

  services = [
    "compute.googleapis.com",
    "oslogin.googleapis.com",
    "dlp.googleapis.com",
  ]
}

resource "google_compute_shared_vpc_service_project" "in_scope_cde" {
  host_project    = "${google_project.pci_shared.project_id}"
  service_project = "${google_project.in_scope_cde.project_id}"

  depends_on = ["google_compute_shared_vpc_host_project.pci_shared",
    "google_project_services.in_scope_cde",
  ]
}

output "in_scope_cde_project_id" {
  value = "${google_project.in_scope_cde.project_id}"
}
