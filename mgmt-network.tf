# Create the hosted network.
resource "google_compute_network" "mgmt_shared_network" {
  name                    = "mgmt-shared-network"
  auto_create_subnetworks = "false"
  project                 = "${google_compute_shared_vpc_host_project.mgmt_shared.project}"
}

resource "google_compute_subnetwork" "mgmt_subnets" {
  name             = "mgmt-subnets"
  ip_cidr_range    = "10.100.0.0/20"
  region           = "${var.region}"
  network          = "${google_compute_network.mgmt_shared_network.self_link}"
  project          = "${google_compute_shared_vpc_host_project.mgmt_shared.project}"
  enable_flow_logs = "true"
}
