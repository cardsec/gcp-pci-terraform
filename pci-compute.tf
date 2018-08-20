# Create a VM which hosts a PCI web page
resource "google_compute_instance" "pci_web" {
  name         = "pci-web"
  project      = "${google_project.in_scope_cde.project_id}"
  machine_type = "n1-standard-1"
  zone         = "${var.region_zone}"
  tags = ["pciweb"]

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-9"
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
    name = "pciweb"
  }

  metadata_startup_script = "${file("scripts/apache.sh")}"

  service_account {
      scopes = ["https://www.googleapis.com/auth/compute.readonly"]
    }

  depends_on = ["google_project_services.in_scope_cde"]

}
