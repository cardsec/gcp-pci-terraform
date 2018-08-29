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
