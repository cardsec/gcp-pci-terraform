# PCI application project
resource "random_id" "random" {
  byte_length = 8
}

resource "google_project" "out_of_scope" {
  name            = "out-of-scope-${var.project_name}"
  project_id      = "in-scope-cde-${random_id.random.hex}"
  billing_account = "${var.billing_account}"
  org_id          = "${var.org_id}"
}

resource "google_project_services" "out_of_scope" {
  project = "${google_project.out_of_scope.project_id}"

  services = [
    "compute.googleapis.com",
    "oslogin.googleapis.com",
    "sqladmin.googleapis.com",
    "sql-component.googleapis.com",
  ]
}

resource "google_compute_shared_vpc_service_project" "out_of_scope" {
  host_project    = "${google_project.nonpci_shared.project_id}"
  service_project = "${google_project.out_of_scope.project_id}"

  depends_on = ["google_compute_shared_vpc_host_project.nonpci_shared",
    "google_project_services.out_of_scope",
  ]
}

output "out_of_scope_project_id" {
  value = "${google_project.out_of_scope.project_id}"
}
