module "cloud_run_file_service" {
  source = "../shared/gcp-cloud-run"

  project_name           = data.google_project.app_project.name
  gcp_region             = var.gcp_region
  cloud_run_service_name = "app-file-service"
}

module "cloud_run_api_service" {
  source = "../shared/gcp-cloud-run"

  project_name           = data.google_project.app_project.name
  gcp_region             = var.gcp_region
  cloud_run_service_name = "app-api-service"
}

module "cloud_run_ui_service" {
  source = "../shared/gcp-cloud-run"

  project_name           = data.google_project.app_project.name
  gcp_region             = var.gcp_region
  cloud_run_service_name = "app-ui-service"
}

module "cloudsql_api_service" {
  source = "../shared/gcp-cloudsql"

  project_name = data.google_project.app_project.name
  gcp_region   = var.gcp_region
  environment  = var.environment

  database_name = "api-${var.environment}"
  instance_name = "api-${var.environment}-db"
  service_name  = "api"
  db_tier       = "db-custom-1-3840"

  shared_network_project = var.host_vpc
  allocated_ip_range     = var.allocated_ip_range
  private_network        = data.google_compute_network.shared_network.id

  service_account = module.api_service_service_account.email
}

module "cloud_armor" {
  source = "../shared/gcp-security-policies"

  project_name = var.app_project_name
}

module "load_balancer" {
  source = "../shared/gcp-load-balancer"

  project_name         = data.google_project.app_project.name
  cloud_run_services   = [module.cloud_run_ui_service.cloud_run_service_name, module.cloud_run_api_service.cloud_run_service_name]
  domains              = var.domains
  gcp_region           = var.gcp_region
  environment          = var.environment
  security_policy_name = module.cloud_armor.security_policy_name
  project_number       = data.google_project.app_project.number
}

module "bastion_host" {
  source = "../shared/gcp-bastion-host"

  project                = data.google_project.app_project.name
  region                 = var.gcp_region
  environment            = var.environment
  private_network        = data.google_compute_network.shared_network.id
  subnet                 = data.google_compute_subnetwork.env_subnet.id
  bastion_host_sa        = module.bastion_host_service_account.email
  bastion_host_accessors = [var.groups["developers"]]

  api_db_config = {
    instance_connection = module.cloudsql_api_service.cloudsql_instance_connection
    db_name             = module.cloudsql_api_service.db_name
    db_user_secret      = module.cloudsql_api_service.db_user_secret
    db_pass_secret      = module.cloudsql_api_service.db_pass_secret
  }
}

module "sftp_server" {
  source = "../shared/gcp-sftp-server"

  project         = var.app_project_name
  region          = var.gcp_region
  environment     = var.environment
  private_network = data.google_compute_network.shared_network.id
  subnet          = data.google_compute_subnetwork.env_subnet.id
  zone            = "${var.gcp_region}-a"
  sftp_host_sa    = module.sftp_server_service_account.email
  sshKey          = ""
  users           = {}
}

module "workflow" {
  source = "../shared/gcp-workflow"

  project_name = data.google_project.app_project.name
  region       = var.gcp_region
  workflow_sa  = module.workflow_service_account.email

  trigger_buckets = ["proto-legion-sbxdev-upload"]
}

module "notifications" {
  source = "../shared/gcp-notifications"

  project          = data.google_project.app_project.name
  environment      = var.environment
  alert_recipients = var.alert_recipients
}

module "monitoring_dashboard" {
  source = "../shared/gcp-monitoring-dashboard"

  project_name = data.google_project.app_project.name
  environment  = var.environment
}
