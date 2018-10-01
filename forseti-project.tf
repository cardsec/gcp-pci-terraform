# forseti project
resource "google_project" "forseti" {
  name            = "forseti-${var.project_name}"
  project_id      = "forseti-${random_id.random.hex}"
  billing_account = "${var.billing_account2}"
  org_id          = "${var.org_id}"
}

resource "google_project_services" "forseti" {
  project = "${google_project.forseti.project_id}"

  services = [
    "compute.googleapis.com",
    "oslogin.googleapis.com",
  ]
}

resource "google_compute_shared_vpc_service_project" "forseti" {
  host_project    = "${google_project.nonpci_shared.project_id}"
  service_project = "${google_project.forseti.project_id}"

  depends_on = ["google_compute_shared_vpc_host_project.nonpci_shared",
    "google_project_services.forseti",
  ]
}

# create foresti service account
resource "google_service_account" "forseti" {
  account_id   = "foresti"
  display_name = "forseti service account"
  project = "${google_project.forseti.project_id}"
}

resource "google_service_account_key" "forseti" {
  service_account_id = "${google_service_account.forseti.name}"
}

resource "google_organization_iam_binding" "resourcemgr_org_admin" {
  org_id = "${var.org_id}"
  role    = "roles/resourcemanager.organizationAdmin"
  members = ["serviceAccount:${google_service_account.forseti.email}"]
}

resource "google_project_iam_binding" "compute_admin" {
  project = "${google_project.forseti.project_id}"
  role = "roles/compute.instanceAdmin"
  members = [ "serviceAccount:${google_service_account.forseti.email}" ]
}

resource "google_project_iam_binding" "compute_network_viewer" {
  project = "${google_project.forseti.project_id}"
  role = "roles/compute.instanceAdmin"
  members = [ "serviceAccount:${google_service_account.forseti.email}" ]
}

resource "google_project_iam_binding" "compute_security_admin" {
  project = "${google_project.forseti.project_id}"
  role = "roles/compute.instanceAdmin"
  members = [ "serviceAccount:${google_service_account.forseti.email}" ]
}

resource "google_project_iam_binding" "dm_editor" {
  project = "${google_project.forseti.project_id}"
  role = "roles/deploymentmanager.editor"
  members = [ "serviceAccount:${google_service_account.forseti.email}" ]
}

resource "google_project_iam_binding" "iam_serviceaccount_admin" {
  project = "${google_project.forseti.project_id}"
  role = "roles/iam.serviceAccountAdmin"
  members = [ "serviceAccount:${google_service_account.forseti.email}" ]
}

resource "google_project_iam_binding" "iam_serviceaccount_user" {
  project = "${google_project.forseti.project_id}"
  role = "roles/iam.serviceAccountUser"
  members = [ "serviceAccount:${google_service_account.forseti.email}" ]
}

resource "google_project_iam_binding" "serviceusage_admin" {
  project = "${google_project.forseti.project_id}"
  role = "roles/serviceusage.serviceUsageAdmin"
  members = [ "serviceAccount:${google_service_account.forseti.email}" ]
}

resource "google_project_iam_binding" "storage_admin" {
  project = "${google_project.forseti.project_id}"
  role = "roles/storage.admin"
  members = [ "serviceAccount:${google_service_account.forseti.email}" ]
}

output "forseti_project_id" {
  value = "${google_project.forseti.project_id}"
}
