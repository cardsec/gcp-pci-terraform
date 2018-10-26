resource "random_id" "mgmt_id" {
  byte_length = 8
}

resource "google_project" "mgmt_shared" {
  name            = "mgmt-${var.project_name}"
  project_id      = "mgmt-${random_id.pci_id.hex}"
  billing_account = "${var.billing_account}"
  org_id          = "${var.org_id}"
}

resource "google_project_services" "mgmt_shared" {
  project = "${google_project.mgmt_shared.project_id}"

  services = [
    "compute.googleapis.com",
    "oslogin.googleapis.com",
  ]
}

# Enable shared VPC hosting in the host project.
resource "google_compute_shared_vpc_host_project" "mgmt_shared" {
  project    = "${google_project.mgmt_shared.project_id}"
  depends_on = ["google_project_services.mgmt_shared"]
}

output "mgmt_project_id" {
  value = "${google_project.mgmt_shared.project_id}"
}
