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
#create ip address for GCE
resource "google_compute_address" "nonpci_web" {
  name       = "nonpci-web"
  project    = "${google_project.out_of_scope.project_id}"
  region     = "${var.region}"
  depends_on = ["google_project_services.out_of_scope"]
}

# Create a VM which hosts a nonpci web page
resource "google_compute_instance" "nonpci_web" {
  name         = "nonpci-web"
  project      = "${google_project.out_of_scope.project_id}"
  machine_type = "n1-standard-1"
  zone         = "${var.region_zone}"
  tags         = ["nonpciweb"]

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-9"
    }
  }

  scratch_disk {}

  network_interface {
    subnetwork = "${google_compute_subnetwork.nonpci_subnets.self_link}"

    access_config {
      nat_ip = "${google_compute_address.nonpci_web.address}"
    }
  }

  metadata {
    name = "nonpciweb"
  }

  metadata_startup_script = "${file("scripts/nonpci-apache.sh")}"

  service_account {
    scopes = ["https://www.googleapis.com/auth/compute.readonly"]
  }

  depends_on = ["google_project_services.out_of_scope", "google_compute_address.nonpci_web"]
}

output "nonpci_web_ecs_address" {
  value = "${google_compute_address.nonpci_web.address}"
}
