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
