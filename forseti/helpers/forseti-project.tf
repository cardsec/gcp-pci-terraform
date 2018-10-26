# forseti project
resource "random_id" "random" {
  byte_length = 8
}
resource "google_project" "forseti" {
  name            = "forseti-${var.project_name}"
  project_id      = "forseti-${random_id.random.hex}"
  billing_account = "${var.billing_account}"
  org_id          = "${var.org_id}"
}

resource "google_project_services" "forseti" {
  project = "${google_project.forseti.project_id}"

  services = [
    "compute.googleapis.com",
    "oslogin.googleapis.com",
    "servicemanagement.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "admin.googleapis.com",
    "bigquery-json.googleapis.com",
    "cloudbilling.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "deploymentmanager.googleapis.com",
    "iam.googleapis.com",
  ]
}

resource "google_compute_shared_vpc_service_project" "forseti" {
  host_project    = "${var.vpc_project}"
  service_project = "${google_project.forseti.project_id}"

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

#Roles Granted at the organization level
resource "google_organization_iam_binding" "appengine" {
  org_id = "${var.org_id}"
  role    = "roles/appengine.appViewer"
  members = ["serviceAccount:${google_service_account.forseti.email}"]
}

resource "google_organization_iam_binding" "bq" {
  org_id = "${var.org_id}"
  role    = "roles/bigquery.dataViewer"
  members = ["serviceAccount:${google_service_account.forseti.email}"]
}

resource "google_organization_iam_binding" "browser" {
  org_id = "${var.org_id}"
  role    = "roles/browser"
  members = ["serviceAccount:${google_service_account.forseti.email}"]
}

resource "google_organization_iam_binding" "cloudsql" {
  org_id = "${var.org_id}"
  role    = "roles/cloudsql.viewer"
  members = ["serviceAccount:${google_service_account.forseti.email}"]
}

resource "google_organization_iam_binding" "compute_network" {
  org_id = "${var.org_id}"
  role    = "roles/compute.networkViewer"
  members = ["serviceAccount:${google_service_account.forseti.email}"]
}

resource "google_organization_iam_binding" "compute_security" {
  org_id = "${var.org_id}"
  role    = "roles/compute.securityAdmin"
  members = ["serviceAccount:${google_service_account.forseti.email}"]
}

resource "google_organization_iam_binding" "iam" {
  org_id = "${var.org_id}"
  role    = "roles/iam.securityReviewer"
  members = ["serviceAccount:${google_service_account.forseti.email}"]
}

resource "google_organization_iam_binding" "servicemanagement" {
  org_id = "${var.org_id}"
  role    = "roles/servicemanagement.quotaViewer"
  members = ["serviceAccount:${google_service_account.forseti.email}"]
}

resource "google_organization_iam_binding" "serviceusage" {
  org_id = "${var.org_id}"
  role    = "roles/serviceusage.serviceUsageConsumer"
  members = ["serviceAccount:${google_service_account.forseti.email}"]
}

#Granted at the project level

resource "google_project_iam_binding" "cloudsql" {
  project = "${google_project.forseti.project_id}"
  role = "roles/cloudsql.client"
  members = [ "serviceAccount:${google_service_account.forseti.email}" ]
}

resource "google_project_iam_binding" "logging" {
  project = "${google_project.forseti.project_id}"
  role = "roles/logging.logWriter"
  members = [ "serviceAccount:${google_service_account.forseti.email}" ]
}

resource "google_project_iam_binding" "storage" {
  project = "${google_project.forseti.project_id}"
  role = "roles/storage.objectViewer"
  members = [ "serviceAccount:${google_service_account.forseti.email}" ]
}
resource "google_project_iam_binding" "storage_creator" {
  project = "${google_project.forseti.project_id}"
  role = "roles/storage.objectCreator"
  members = [ "serviceAccount:${google_service_account.forseti.email}" ]
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

#Granted at the service account level
resource "google_service_account_iam_binding" "admin-account-iam" {
  service_account_id = "projects/${google_project.forseti.project_id}/serviceAccounts/${google_service_account.forseti.email}"
  role        = "roles/iam.serviceAccountTokenCreator"
  members = [ "serviceAccount:${google_service_account.forseti.email}" ]
}

output "forseti_project_id" {
  value = "${google_project.forseti.project_id}"
}

output "foresti_service_account" {
  value = "${google_service_account.forseti.email}"
}
