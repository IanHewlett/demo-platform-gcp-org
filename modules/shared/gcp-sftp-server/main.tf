resource "google_compute_instance" "sftp" {
  project                   = var.project
  name                      = "${var.environment}-sftp"
  machine_type              = "e2-standard-2"
  zone                      = var.zone
  allow_stopping_for_update = true

  tags = [
    "allow-ssh-iap",
    "net-lb-ext-healthcheck-nonprod",
    "sftp-allow-22-nonprod",
  ]

  labels = {
    environment           = var.environment
    goog-ops-agent-policy = "v2-x86-template-1-0-0"
  }

  metadata = {
    enable-osconfig         = "TRUE"
    enable-guest-attributes = "TRUE"
    ssh-keys                = <<EOT
${var.sshKey}
    EOT
  }

  metadata_startup_script = templatefile(
    "${path.module}/files/startup.sh",
    {
      environment = var.environment,
      project     = var.project,
      users       = var.users
    }
  )


  boot_disk {
    auto_delete = true

    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network    = var.private_network
    subnetwork = var.subnet
  }

  service_account {
    email  = var.sftp_host_sa
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance_group" "sftp" {
  project     = var.project
  name        = "${var.environment}-sftp-instance-group"
  description = "SFTP instance group"
  network     = var.private_network
  zone        = var.zone

  named_port {
    name = "sftp"
    port = "22"
  }
}

resource "google_compute_instance_group_membership" "sftp_membership" {
  project        = var.project
  zone           = var.zone
  instance       = google_compute_instance.sftp.self_link
  instance_group = google_compute_instance_group.sftp.name

  lifecycle {
    replace_triggered_by = [
      google_compute_instance.sftp.id
    ]
  }
}

resource "google_compute_region_backend_service" "sftp" {
  provider = google-beta

  project = var.project
  name    = "${var.environment}-sftp-backend-service"
  region  = var.region

  backend {
    group = google_compute_instance_group.sftp.self_link
  }

  load_balancing_scheme = "EXTERNAL"

  health_checks = [
    google_compute_region_health_check.sftp.id,
  ]

  log_config {
    enable      = true
    sample_rate = 1
  }
}

resource "google_compute_forwarding_rule" "sftp" {
  provider = google-beta

  project     = var.project
  region      = var.region
  name        = "${var.environment}-sftp-forwarding-rule"
  ip_address  = google_compute_address.sftp.address
  ip_protocol = "TCP"

  backend_service = (
    google_compute_region_backend_service.sftp.self_link
  )

  load_balancing_scheme = "EXTERNAL"
  port_range            = "22"
}
