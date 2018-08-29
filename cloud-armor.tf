#deny all execpt for company ip range
resource "google_compute_security_policy" "pci_policy" {
  name       = "pci-policy"
  project    = "${google_project.in_scope_cde.project_id}"
  depends_on = ["google_project_services.in_scope_cde"]

  rule {
    action   = "deny(404)"
    priority = "2147483647"

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = ["*"]
      }
    }

    description = "Deny all - default rule"
  }

  rule {
    action   = "allow"
    priority = "100"

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = ["198.58.5.0/24"]
      }
    }

    description = "allow company ips"
  }
}
