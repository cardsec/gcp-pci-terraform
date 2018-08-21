resource "random_id" "pci_id" {
 byte_length = 8
}

resource "google_project" "pci_shared" {
 name            = "pci-x-${var.project_name}"
 project_id      = "pci-${random_id.pci_id.hex}"
 billing_account = "${var.billing_account}"
 org_id          = "${var.org_id}"
}

resource "google_project_services" "pci_shared" {
 project = "${google_project.pci_shared.project_id}"
 services = [
   "compute.googleapis.com",
   "oslogin.googleapis.com"
 ]
}

# Enable shared VPC hosting in the host project.
resource "google_compute_shared_vpc_host_project" "pci_shared" {
  project    = "${google_project.pci_shared.project_id}"
  depends_on = ["google_project_services.pci_shared"]
}

# Create the hosted network.
resource "google_compute_network" "pci_shared_network" {
  name                    = "pci-shared-network"
  auto_create_subnetworks = "true"
  project                 = "${google_compute_shared_vpc_host_project.pci_shared.project}"
  depends_on              = ["google_compute_shared_vpc_service_project.in_scope_cde"]
}

# Allow the hosted network to be hit over ICMP, SSH, and HTTP.
resource "google_compute_firewall" "pci_shared_network" {
  name  = "allow-ssh-icmp"
  network = "${google_compute_network.pci_shared_network.self_link}"
  project = "${google_compute_network.pci_shared_network.project}"
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
}

# PCI application project
resource "google_project" "in_scope_cde" {
  name = "in-scope-cde-${var.project_name}"
  project_id = "in-scope-cde-${random_id.pci_id.hex}"
  billing_account = "${var.billing_account}"
  org_id          = "${var.org_id}"
}

resource "google_project_services" "in_scope_cde" {
 project = "${google_project.in_scope_cde.project_id}"
 services = [
   "compute.googleapis.com",
   "oslogin.googleapis.com",
   "sqladmin.googleapis.com",
   "sql-component.googleapis.com",
   "dlp.googleapis.com"
 ]
}

resource "google_compute_shared_vpc_service_project" "in_scope_cde" {
  host_project = "${google_project.pci_shared.project_id}"
  service_project = "${google_project.in_scope_cde.project_id}"
  depends_on = ["google_compute_shared_vpc_host_project.pci_shared", "google_project_services.in_scope_cde"]
}

output "pci_project_id" {
 value = "${google_project.pci_shared.project_id}"
}
