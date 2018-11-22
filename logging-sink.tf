#example of an org sink with a filter for activity logs with severity >= WARNING
resource "google_logging_organization_sink" "org_sink" {
    name        = "org-sink"
    org_id      = "${var.org_id}"
    destination = "storage.googleapis.com/${google_storage_bucket.log_bucket.name}"
    filter      = "logName:activity AND severity >= WARNING"
    include_children = "true"
}


# Because our sink uses a unique_writer, we must grant that writer access to the bucket.
resource "google_project_iam_binding" "log_writer" {
  role    = "roles/storage.objectCreator"
  project = "${google_project.logging.project_id}"
  members = [
    "${google_logging_organization_sink.org_sink.writer_identity}",
  ]
}

#log sink for the inscope project with a filter for gce and publish to pubsub
resource "google_logging_project_sink" "pci_gce_sink" {
    name = "pci-gce-sink"
    destination = "pubsub.googleapis.com/projects/${google_project.logging.project_id}/topics/pci-instance-activity"
    filter = "resource.type=gce_instance"
    unique_writer_identity = true
    project = "${google_project.in_scope_cde.project_id}"
}

resource "google_project_iam_binding" "pubsub-writer" {
  role = "roles/pubsub.publisher"
  project = "${google_project.logging.project_id}"
  members = [
    "${google_logging_project_sink.pci_gce_sink.writer_identity}"
  ]
}
