resource "google_compute_security_policy" "policy" {
  name    = "${var.project_name}-policy"
  project = var.project_name

  adaptive_protection_config {
    layer_7_ddos_defense_config {
      enable = true
    }
  }
}
