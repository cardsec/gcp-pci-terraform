resource "google_compute_firewall" "pci_firewall" {
  name    = "pci-firewall"
  network = "${google_compute_network.pci_shared_network.self_link}"
  project = "${google_compute_network.pci_shared_network.project}"
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_tags = ["pciweb"]
}
