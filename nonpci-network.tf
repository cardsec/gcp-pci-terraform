# Create the hosted network.
resource "google_compute_network" "nonpci_shared_network" {
  name                    = "nonpci-shared-network"
  auto_create_subnetworks = "false"
  project                 = "${google_compute_shared_vpc_host_project.nonpci_shared.project}"
}

resource "google_compute_subnetwork" "nonpci_subnets" {
  name              = "nonpci-subnets"
  ip_cidr_range     = "10.30.0.0/20"
  region            = "${var.region}"
  network           = "${google_compute_network.nonpci_shared_network.self_link}"
  project           = "${google_compute_shared_vpc_host_project.nonpci_shared.project}"
  enable_flow_logs  = "true"
}
