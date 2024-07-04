resource "google_compute_global_address" "static_ip_address" {
  name    = "static-ip-address"
  project = var.project_name
}

resource "google_compute_managed_ssl_certificate" "managed_cert" {
  name    = "managed-cert"
  project = var.project_name

  managed {
    domains = var.domains
  }
}

resource "google_compute_region_network_endpoint_group" "serverless_api" {
  name    = "ingress-${var.environment}-neg-api"
  region  = var.gcp_region
  project = var.project_name

  cloud_run {
    service = var.cloud_run_service_name_api
  }
}

resource "google_compute_region_network_endpoint_group" "serverless_ui" {
  name    = "ingress-${var.environment}-neg-ui"
  region  = var.gcp_region
  project = var.project_name

  cloud_run {
    service = var.cloud_run_service_name_ui
  }
}

resource "google_compute_backend_service" "api" {
  name      = "ingress-${var.environment}-api"
  port_name = "http"
  protocol  = "HTTPS"
  project   = var.project_name

  backend {
    group = google_compute_region_network_endpoint_group.serverless_api.id
  }

  iap {
    oauth2_client_id     = google_iap_client.iap_client.client_id
    oauth2_client_secret = google_iap_client.iap_client.secret
  }
}

resource "google_compute_backend_service" "ui" {
  name      = "ingress-${var.environment}-ui"
  port_name = "http"
  protocol  = "HTTPS"
  project   = var.project_name

  backend {
    group = google_compute_region_network_endpoint_group.serverless_ui.id
  }

  iap {
    oauth2_client_id     = google_iap_client.iap_client.client_id
    oauth2_client_secret = google_iap_client.iap_client.secret
  }
}

resource "google_compute_global_forwarding_rule" "default" {
  name        = "ingress-${var.environment}"
  target      = google_compute_target_https_proxy.default.id
  ip_address  = google_compute_global_address.static_ip_address.id
  ip_protocol = "TCP"
  port_range  = "443-443"
  project     = var.project_name
}

resource "google_compute_target_https_proxy" "default" {
  name    = "ingress-${var.environment}"
  url_map = google_compute_url_map.default.id
  project = var.project_name

  ssl_certificates = [
    google_compute_managed_ssl_certificate.managed_cert.id
  ]
}

resource "google_compute_url_map" "default" {
  name            = "ingress-${var.environment}"
  default_service = google_compute_backend_service.ui.id
  project         = var.project_name

  host_rule {
    hosts        = var.domains
    path_matcher = "tld-path"
  }

  path_matcher {
    default_service = google_compute_backend_service.ui.id
    name            = "tld-path"

    path_rule {
      paths = [
        "/api/*",
      ]
      service = google_compute_backend_service.api.id
    }
  }
}
