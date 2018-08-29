resource "google_project" "stackdriver" {
  name            = "stackdriver-${var.project_name}"
  project_id      = "stackdriver-${random_id.pci_id.hex}"
  billing_account = "${var.billing_account}"
  org_id          = "${var.org_id}"
}

resource "google_project_services" "stackdriver" {
  project = "${google_project.stackdriver.project_id}"

  services = [
    "compute.googleapis.com",
    "oslogin.googleapis.com",
  ]
}

resource "google_compute_shared_vpc_service_project" "stackdriver" {
  host_project    = "${google_project.nonpci_shared.project_id}"
  service_project = "${google_project.stackdriver.project_id}"

  depends_on = ["google_compute_shared_vpc_host_project.nonpci_shared",
    "google_project_services.stackdriver",
  ]
}

resource "google_storage_bucket" "log_bucket" {
  name    = "logging-bucket-${var.project_name}-${random_id.pci_id.hex}"
  project = "${google_project.stackdriver.project_id}"
}

resource "google_logging_project_sink" "instance_sink" {
  name                   = "instance-sink"
  destination            = "storage.googleapis.com/${google_storage_bucket.log_bucket.name}"
  filter                 = "resource.type = gce_instance AND resource.labels.instance_id = \"${google_compute_instance.pci_web.instance_id}\""
  project                = "${google_project.stackdriver.project_id}"
  unique_writer_identity = true
}

# Because our sink uses a unique_writer, we must grant that writer access to the bucket.
resource "google_project_iam_binding" "log_writer" {
  role    = "roles/storage.objectCreator"
  project = "${google_project.stackdriver.project_id}"

  members = [
    "${google_logging_project_sink.instance_sink.writer_identity}",
  ]

  depends_on = ["google_logging_project_sink.instance_sink"]
}
