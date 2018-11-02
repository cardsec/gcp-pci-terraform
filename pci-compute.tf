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
resource "google_compute_address" "pci_web" {
  name = "pci-web"
  project      = "${google_project.in_scope_cde.project_id}"
  region = "${var.region}"
  depends_on = ["google_project_services.in_scope_cde"]
}

# Create a VM which hosts a PCI web page
resource "google_compute_instance" "pci_web" {
  name         = "pci-web"
  project      = "${google_project.in_scope_cde.project_id}"
  machine_type = "n1-standard-1"
  zone         = "${var.region_zone}"
  depends_on   = ["google_project_services.in_scope_cde", "google_compute_address.pci_web"]
  tags         = ["pciweb"]

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-9"
    }
  }
  scratch_disk {
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.pci_subnets.self_link}"
    access_config {
      nat_ip = "${google_compute_address.pci_web.address}"
    }
  }
  metadata {
    name = "pciweb"
  }
  metadata_startup_script = "${file("scripts/pci-apache.sh")}"
  service_account {
      scopes = ["https://www.googleapis.com/auth/compute.readonly"]
  }
}


resource "google_compute_backend_service" "pci_web" {
  name = "pci-web-backend"
  port_name   = "http"
  protocol    = "HTTP"
  project      = "${google_project.in_scope_cde.project_id}"
  timeout_sec = 10
  enable_cdn  = false
  security_policy = "${google_compute_security_policy.pci_policy.self_link}"
  health_checks = ["${google_compute_http_health_check.default.self_link}"]

  backend {
    group = "${google_compute_instance_group.pci_webservers.self_link}"
  }

}

resource "google_compute_instance_group" "pci_webservers" {
  name               = "pci-webservers"
  zone               = "${var.region_zone}"
  project            = "${google_project.in_scope_cde.project_id}"
  instances          = [ "${google_compute_instance.pci_web.self_link}"]

  named_port {
    name = "http"
    port = "80"
  }
}

resource "google_compute_target_pool" "pci_web" {
  name = "pci-web-pool"
  project = "${google_project.in_scope_cde.project_id}"

  instances = [
    "${google_compute_instance.pci_web.self_link}",
  ]

  health_checks = [
    "${google_compute_http_health_check.default.self_link}",
  ]
}

resource "google_compute_http_health_check" "default" {
  name = "default"
  request_path = "/"
  project      = "${google_project.in_scope_cde.project_id}"

}

output "pci_web_ecs_address" {
  value = "${google_compute_address.pci_web.address}"
}
