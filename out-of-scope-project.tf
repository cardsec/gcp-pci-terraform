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
resource "random_id" "random" {
  byte_length = 8
}

resource "google_project" "out_of_scope" {
  name            = "out-of-scope-${var.project_name}"
  project_id      = "out-scope-cde-${random_id.random.hex}"
  billing_account = "${var.billing_account}"
  org_id          = "${var.org_id}"
}

resource "google_project_services" "out_of_scope" {
  project = "${google_project.out_of_scope.project_id}"

  services = [
    "compute.googleapis.com",
    "oslogin.googleapis.com",
    "sqladmin.googleapis.com",
    "sql-component.googleapis.com",
  ]
}

resource "google_compute_shared_vpc_service_project" "out_of_scope" {
  host_project    = "${google_project.nonpci_shared.project_id}"
  service_project = "${google_project.out_of_scope.project_id}"

  depends_on = ["google_compute_shared_vpc_host_project.nonpci_shared",
    "google_project_services.out_of_scope",
  ]
}

output "out_of_scope_project_id" {
  value = "${google_project.out_of_scope.project_id}"
}
