resource "google_compute_firewall" "pci_firewall" {
  name    = "pci-firewall"
  network = "${google_compute_network.pci_shared_network.self_link}"
  project = "${google_compute_network.pci_shared_network.project}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  source_tags = ["pciweb"]
}

resource "google_compute_firewall" "pci_sq_firewall" {
  name = "pci-sql-firewall"
  network = "${google_compute_network.pci_shared_network.self_link}"
  project = "${google_compute_network.pci_shared_network.project}"

  allow {
    protocol = "tcp"
    ports = ["3306"]

  }

  source_tags = ["pciweb"]
}
