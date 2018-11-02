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
resource "random_id" "mgmt_id" {
  byte_length = 8
}

resource "google_project" "mgmt_shared" {
  name            = "mgmt-${var.project_name}"
  project_id      = "mgmt-${random_id.pci_id.hex}"
  billing_account = "${var.billing_account}"
  org_id          = "${var.org_id}"
}

resource "google_project_services" "mgmt_shared" {
  project = "${google_project.mgmt_shared.project_id}"

  services = [
    "compute.googleapis.com",
    "oslogin.googleapis.com",
  ]
}

# Enable shared VPC hosting in the host project.
resource "google_compute_shared_vpc_host_project" "mgmt_shared" {
  project    = "${google_project.mgmt_shared.project_id}"
  depends_on = ["google_project_services.mgmt_shared"]
}

output "mgmt_project_id" {
  value = "${google_project.mgmt_shared.project_id}"
}
