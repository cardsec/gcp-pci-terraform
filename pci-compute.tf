# Create a VM which hosts a PCI web page
resource "google_compute_instance" "pci_web" {
  name         = "pci-web"
  project      = "${google_project.in_scope_cde.project_id}"
  machine_type = "f1-micro"
  zone         = "${var.region_zone}"
  tags = ["name", "pci-web "]

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-8"
    }
  }

  // Local SSD disk
  scratch_disk {
  }

  network_interface {
    network = "${google_compute_network.pci_shared_network.self_link}"

    access_config {
      // Ephemeral IP
    }
  }

  metadata {
    name = "pci-web"
  }

  metadata_startup_script = "echo I am PCI > /test.txt"

  service_account {
      scopes = ["https://www.googleapis.com/auth/compute.readonly"]
    }

  depends_on = ["google_project_services.in_scope_cde"]

}
