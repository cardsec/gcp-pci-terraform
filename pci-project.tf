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
   "compute.googleapis.com"
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
}

output "pci_project_id" {
 value = "${google_project.pci_shared.project_id}"
}
