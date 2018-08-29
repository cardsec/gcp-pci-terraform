resource "random_id" "nonpci_id" {
  byte_length = 8
}

resource "google_project" "nonpci_shared" {
  name            = "nonpci-x-${var.project_name}"
  project_id      = "nonpci-${random_id.pci_id.hex}"
  billing_account = "${var.billing_account}"
  org_id          = "${var.org_id}"
}

resource "google_project_services" "nonpci_shared" {
  project = "${google_project.nonpci_shared.project_id}"

  services = [
    "compute.googleapis.com",
    "oslogin.googleapis.com",
  ]
}

# Enable shared VPC hosting in the host project.
resource "google_compute_shared_vpc_host_project" "nonpci_shared" {
  project    = "${google_project.nonpci_shared.project_id}"
  depends_on = ["google_project_services.nonpci_shared"]
}

output "nonpci_project_id" {
  value = "${google_project.nonpci_shared.project_id}"
}
