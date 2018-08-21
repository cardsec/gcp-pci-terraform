resource "google_sql_database_instance" "pci_master" {
  name = "pci-master-instance"
  database_version = "MYSQL_5_7"
  region = "${var.region}"
  project = "${google_project.in_scope_cde.project_id}"

  settings {
    tier = "db-f1-micro"
    location_preference {
        zone = "${var.region_zone}"
    }
    ip_configuration {
      ipv4_enabled = true
      # require_ssl = true
      #authorized_networks = {
      #  name = "The World"
      #  value = "0.0.0.0/0"
      #}
      authorized_networks = {
        name = "${google_compute_instance.pci_web.0.name}"
        value = "${google_compute_address.pci_web.address}/32"
      }
    }
  }
  depends_on = ["google_compute_instance.pci_web", "google_project_services.in_scope_cde"]
}

#resource "google_sql_database" "pci_cc" {
#  name      = "users-cc"
#  instance  = "${google_sql_database_instance.pci_master.name}"
#  depends_on = ["google_sql_database_instance.pci_master"]
#}
