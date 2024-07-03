resource "google_compute_firewall" "non_production_allow_ssh_from_iap" {
  project     = var.network_project_name
  name        = "allow-ssh-from-iap"
  network     = google_compute_network.vpc.self_link
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
