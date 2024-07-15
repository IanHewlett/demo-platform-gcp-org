resource "google_compute_region_network_endpoint_group" "serverless" {
  for_each = var.cloud_run_services

  project = var.project_name
  region  = var.gcp_region

  name = "ingress-${var.environment}-neg-${each.key}"

  cloud_run {
    service = each.key
  }
}

resource "google_compute_backend_service" "serverless" {
  for_each = var.cloud_run_services

  name      = "ingress-${var.environment}-${each.key}"
  port_name = "http"
  protocol  = "HTTPS"
  project   = var.project_name

  security_policy = var.security_policy_name

  backend {
    group = google_compute_region_network_endpoint_group.serverless[each.key].id
  }

  iap {
    oauth2_client_id     = google_iap_client.iap_client.client_id
    oauth2_client_secret = google_iap_client.iap_client.secret
  }
}

resource "google_compute_url_map" "default" {
  name            = "ingress-${var.environment}"
  default_service = google_compute_backend_service.serverless["app-ui-service"].id
  project         = var.project_name

  host_rule {
    hosts        = var.domains
    path_matcher = "tld-path"
  }

  path_matcher {
    default_service = google_compute_backend_service.serverless["app-ui-service"].id
    name            = "tld-path"

    path_rule {
      paths = [
        "/api/*",
      ]
      service = google_compute_backend_service.serverless["app-api-service"].id
    }
  }
}

resource "google_compute_target_https_proxy" "default" {
  name    = "ingress-${var.environment}"
  url_map = google_compute_url_map.default.id
  project = var.project_name

  ssl_certificates = [
    google_compute_managed_ssl_certificate.managed_cert.id
  ]
}

resource "google_compute_global_forwarding_rule" "default" {
  name        = "ingress-${var.environment}"
  target      = google_compute_target_https_proxy.default.id
  ip_address  = google_compute_global_address.static_ip_address.id
  ip_protocol = "TCP"
  port_range  = "443-443"
  project     = var.project_name
}
