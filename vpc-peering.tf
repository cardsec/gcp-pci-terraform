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
resource "google_compute_network_peering" "pci_mgmt_peering" {
  name         = "pcipeering"
  network      = "${google_compute_network.pci_shared_network.self_link}"
  peer_network = "${google_compute_network.mgmt_shared_network.self_link}"
}

resource "google_compute_network_peering" "nonpci_mgmt_peering" {
  name         = "nonpcipeering"
  network      = "${google_compute_network.nonpci_shared_network.self_link}"
  peer_network = "${google_compute_network.mgmt_shared_network.self_link}"
}

resource "google_compute_network_peering" "mgmt_pci_peering" {
  name         = "mgmtpcipeering"
  network      = "${google_compute_network.mgmt_shared_network.self_link}"
  peer_network = "${google_compute_network.pci_shared_network.self_link}"
}

resource "google_compute_network_peering" "mgmt_nonpci_peering" {
  name         = "mgmtnonpcipeering"
  network      = "${google_compute_network.mgmt_shared_network.self_link}"
  peer_network = "${google_compute_network.nonpci_shared_network.self_link}"
}
