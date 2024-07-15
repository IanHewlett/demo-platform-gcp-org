##
# A regional NEG that can support Serverless Products, proxying traffic to external backends and providing traffic to the PSC port mapping endpoints.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_network_endpoint_group
resource "google_compute_region_network_endpoint_group" "serverless" {
  for_each = var.cloud_run_services

  project = var.project_name
  region  = var.gcp_region

  name = "ingress-${var.environment}-neg-${each.key}"

  cloud_run {
    service = each.key
  }
}

##
# A Backend Service defines a group of virtual machines that will serve traffic for load balancing.
# This resource is a global backend service, appropriate for external load balancing or self-managed internal load balancing.
# For managed internal load balancing, use a regional backend service instead.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service
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

##
# UrlMaps are used to route requests to a backend service based on rules that you define for the host and path of an incoming URL.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map
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

##
# Represents a TargetHttpsProxy resource, which is used by one or more global forwarding rule to route incoming HTTPS requests to a URL map.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_https_proxy
resource "google_compute_target_https_proxy" "default" {
  name    = "ingress-${var.environment}"
  url_map = google_compute_url_map.default.id
  project = var.project_name

  ssl_certificates = [
    google_compute_managed_ssl_certificate.managed_cert.id
  ]
}

##
# Represents a GlobalForwardingRule resource.
# Global forwarding rules are used to forward traffic to the correct load balancer for HTTP load balancing.
# Global forwarding rules can only be used for HTTP load balancing.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule
resource "google_compute_global_forwarding_rule" "default" {
  name        = "ingress-${var.environment}"
  target      = google_compute_target_https_proxy.default.id
  ip_address  = google_compute_global_address.static_ip_address.id
  ip_protocol = "TCP"
  port_range  = "443-443"
  project     = var.project_name
}
