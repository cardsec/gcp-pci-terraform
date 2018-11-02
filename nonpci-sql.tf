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
resource "google_sql_database_instance" "nonpci_master" {
  name             = "nonpci-master-instance"
  database_version = "MYSQL_5_7"
  region           = "${var.region}"
  project          = "${google_project.out_of_scope.project_id}"

  settings {
    tier = "db-f1-micro"

    location_preference {
      zone = "${var.region_zone}"
    }

    ip_configuration {
      ipv4_enabled = true

      # require_ssl = true
      authorized_networks = {
        name = "pci"
        value = "${google_compute_address.pci_web.address}/32"
      }
    }
  }

  depends_on = ["google_compute_instance.nonpci_web", "google_project_services.out_of_scope"]
}
