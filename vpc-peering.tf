resource "google_compute_network_peering" "pci_peering" {
  name = "pcipeering"
  network = "${google_compute_network.pci_shared_network.self_link}"
  peer_network = "${google_compute_network.nonpci_shared_network.self_link}"
}

resource "google_compute_network_peering" "nonpci_peering" {
  name = "nonpcipeering"
  network = "${google_compute_network.nonpci_shared_network.self_link}"
  peer_network = "${google_compute_network.pci_shared_network.self_link}"
}
