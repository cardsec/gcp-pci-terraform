#create ip address for GCE
resource "google_compute_address" "pci_web" {
  name = "pci-web"
  project      = "${google_project.in_scope_cde.project_id}"
  region = "${var.region}"
  depends_on = ["google_project_services.in_scope_cde"],
}

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
  scratch_disk {
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.pci_subnets.self_link}"
    access_config {
      nat_ip = "${google_compute_address.pci_web.address}"
    }
  }
  metadata {
    name = "pciweb"
  }
  metadata_startup_script = "${file("scripts/apache.sh")}"
  service_account {
      scopes = ["https://www.googleapis.com/auth/compute.readonly"]
    }
  depends_on = ["google_project_services.in_scope_cde", "google_compute_address.pci_web"]
}


output "pci_web_ecs_address" {
  value = "${google_compute_address.pci_web.address}"
}
