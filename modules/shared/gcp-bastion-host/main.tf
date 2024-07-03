resource "google_compute_instance" "bastion_host" {
  project      = var.project
  name         = "${var.environment}-bastion"
  machine_type = "e2-custom-medium-2816"
  zone         = "us-central1-a"

  tags = ["allow-ssh-iap"]

  labels = {
    environment = var.environment
  }

  boot_disk {
    auto_delete = true

    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = var.private_network
    subnetwork = var.subnet
  }

  service_account {
    email = module.bastion_host_service_account.email

    scopes = ["cloud-platform"]
  }

  #  metadata_startup_script = templatefile("${path.module}/scripts/startup.sh", var.api_db_config)
}
