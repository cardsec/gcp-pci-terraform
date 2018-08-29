resource "google_compute_global_forwarding_rule" "pci_rule" {
  name       = "pci-rule"
  target     = "${google_compute_target_http_proxy.pci_proxy.self_link}"
  project    = "${google_project.in_scope_cde.project_id}"
  port_range = "80"
  depends_on = ["google_project_services.in_scope_cde"]
}

resource "google_compute_target_http_proxy" "pci_proxy" {
  name    = "pci-proxy"
  url_map = "${google_compute_url_map.pci_map.self_link}"
}

resource "google_compute_url_map" "pci_map" {
  name            = "url-map"
  description     = "a description"
  default_service = "${google_compute_backend_service.pci_web.self_link}"

  host_rule {
    hosts        = ["mysite.com"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = "${google_compute_backend_service.pci_web.self_link}"

    path_rule {
      paths   = ["/*"]
      service = "${google_compute_backend_service.pci_web.self_link}"
    }
  }
}

output "ip" {
  value = "{google_compute_global_forwarding_rule.pci_web.ip_address}"
}
