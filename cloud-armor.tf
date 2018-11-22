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
#deny all execpt for company ip range
resource "google_compute_security_policy" "pci_policy" {
  name       = "pci-policy"
  project    = "${google_project.in_scope_cde.project_id}"
  depends_on = ["google_project_services.in_scope_cde"]

  rule {
    action   = "deny(404)"
    priority = "2147483647"

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = ["*"]
      }
    }

    description = "Deny all - default rule"
  }

  rule {
    action   = "allow"
    priority = "100"

    match {
      versioned_expr = "SRC_IPS_V1"
      # add your own ip address range
      config {
        src_ip_ranges = ["*"]
      }
    }

    description = "allow company ips"
  }
}
