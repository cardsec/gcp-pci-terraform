/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
resource "google_compute_global_forwarding_rule" "pci_rule" {
  name       = "pci-rule"
  target     = "${google_compute_target_http_proxy.pci_proxy.self_link}"
  project    = "${google_project.in_scope_cde.project_id}"
  port_range = "80"
  depends_on = ["google_project_services.in_scope_cde"]
}

resource "google_compute_target_http_proxy" "pci_proxy" {
  name    = "pci-proxy"
  project    = "${google_project.in_scope_cde.project_id}"
  url_map = "${google_compute_url_map.pci_map.self_link}"
}

resource "google_compute_url_map" "pci_map" {
  name            = "url-map"
  description     = "a description"
  project    = "${google_project.in_scope_cde.project_id}"
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
