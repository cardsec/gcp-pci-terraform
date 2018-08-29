resource "google_sql_database_instance" "nonpci_master" {
  name             = "nonpci-master-instance"
  database_version = "MYSQL_5_7"
  region           = "${var.region}"
  project          = "${google_project.out_of_scope.project_id}"

  settings {
    tier = "db-f1-micro"

    location_preference {
      zone = "${var.region_zone}"
    }

    ip_configuration {
      ipv4_enabled = true

      # require_ssl = true
      authorized_networks = {
        name = "pci"
        value = "${google_compute_address.pci_web.address}/32"
      }
    }
  }

  depends_on = ["google_compute_instance.nonpci_web", "google_project_services.out_of_scope"]
}
