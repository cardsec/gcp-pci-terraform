resource "google_sql_database_instance" "pci_master" {
  name = "pci-master-instance"
  database_version = "MYSQL_5_6"
  region = "${var.region}"
  project = "${google_project.in_scope_cde.project_id}"

  settings {
    tier = "D0"
    location_preference {
      zone = "${var.region_zone}"
    }
    ip_configuration {
      ipv4_enabled = "true"
    }
  }
}

resource "google_sql_database" "pci_cc" {
  name      = "users-cc"
  instance  = "${google_sql_database_instance.pci_master.name}"
  project = "${google_project.in_scope_cde.project_id}"
}
