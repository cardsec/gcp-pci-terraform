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
resource "google_compute_firewall" "nonnonpci_firewall" {
  name          = "nonpci-firewall"
  network       = "${google_compute_network.nonpci_shared_network.self_link}"
  project       = "${google_compute_network.nonpci_shared_network.project}"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_tags = ["nonpciweb"]
}

#Allow the hosted network to be hit over ICMP, SSH
resource "google_compute_firewall" "nonpci_shared_network" {
  name    = "allow-ssh-icmp"
  network = "${google_compute_network.nonpci_shared_network.self_link}"
  project = "${google_compute_network.nonpci_shared_network.project}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
