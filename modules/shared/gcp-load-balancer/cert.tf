## Create an SSL Certificate
# An SslCertificate resource, used for HTTPS load balancing.
# This resource represents a certificate for which the certificate secrets are created and managed by Google.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_managed_ssl_certificate
resource "google_compute_managed_ssl_certificate" "managed_cert" {
  name    = "managed-cert"
  project = var.project_name

  managed {
    domains = var.domains
  }
}
