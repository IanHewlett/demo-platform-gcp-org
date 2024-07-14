resource "google_compute_firewall" "non_production_allow_ssh_from_iap" {
  project     = var.project_name
  name        = "allow-ssh-from-iap"
  network     = var.network_link
  description = "Allow range used by IAP for tcp forwarding."

  target_tags = ["allow-ssh-iap"]

  source_ranges = [
    "35.235.240.0/20"
  ]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "non_production_sftp_hc" {
  project     = var.project_name
  name        = "net-lb-ext-healthcheck"
  network     = var.network_link
  description = "Allow health check traffic for external passthrough network load balancer."

  target_tags = ["net-lb-ext-healthcheck-nonprod"]

  source_ranges = [
    "35.191.0.0/16",
    "209.85.152.0/22",
    "209.85.204.0/22"
  ]

  allow {
    protocol = "tcp"
  }
}
