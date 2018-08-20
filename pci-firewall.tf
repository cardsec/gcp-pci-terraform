resource "google_compute_firewall" "pci_firewall" {
  name    = "pci-firewall"
  network = "${google_compute_network.pci_shared_network.self_link}"
  project = "${google_project.in_scope_cde.project_id}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  source_tags = ["pciweb"]
}
