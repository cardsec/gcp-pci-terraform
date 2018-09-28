resource "google_compute_firewall" "pci_firewall" {
  name          = "pci-firewall"
  network       = "${google_compute_network.pci_shared_network.self_link}"
  project       = "${google_compute_network.pci_shared_network.project}"
  depends_on    = ["google_project_services.in_scope_cde"]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = ["pciweb"]
}

#Allow the hosted network to be hit over ICMP, SSH
resource "google_compute_firewall" "pci_shared_network" {
  name    = "allow-ssh-icmp"
  network = "${google_compute_network.pci_shared_network.self_link}"
  project = "${google_compute_network.pci_shared_network.project}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
