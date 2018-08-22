# Create the hosted network.
resource "google_compute_network" "pci_shared_network" {
  name                    = "pci-shared-network"
  auto_create_subnetworks = "false"
  project                 = "${google_compute_shared_vpc_host_project.pci_shared.project}"
}

resource "google_compute_subnetwork" "pci_subnets" {
  name              = "pci-subnets"
  ip_cidr_range     = "10.2.0.0/20"
  region            = "${var.region}"
  network           = "${google_compute_network.pci_shared_network.self_link}"
  project           = "${google_compute_shared_vpc_host_project.pci_shared.project}"
  enable_flow_logs  = "true"
}
