module "cloud_run_file_service" {
  source = "../shared/gcp-cloud-run"

  project_name           = var.app_project_name
  gcp_region             = var.gcp_region
  cloud_run_service_name = "app-file-service"

  service_account_roles = [
    "roles/cloudtrace.agent"
  ]
}

module "cloud_run_api_service" {
  source = "../shared/gcp-cloud-run"

  project_name           = var.app_project_name
  gcp_region             = var.gcp_region
  cloud_run_service_name = "app-api-service"

  service_account_roles = [
    "roles/cloudsql.client",
    "roles/cloudsql.viewer",
    "roles/cloudtrace.agent"
  ]
}

module "cloud_run_ui_service" {
  source = "../shared/gcp-cloud-run"

  project_name           = var.app_project_name
  gcp_region             = var.gcp_region
  cloud_run_service_name = "app-ui-service"

  service_account_roles = []
}

module "cloudsql_api_service" {
  source = "../shared/gcp-cloudsql"

  project_name           = var.app_project_name
  gcp_region             = var.gcp_region
  allocated_ip_range     = var.allocated_ip_range
  db_tier                = "db-custom-1-3840"
  environment            = var.environment
  api_service_account    = module.cloud_run_api_service.service_runner_email
  shared_network_project = var.host_vpc
}

module "load_balancer" {
  source = "../shared/gcp-load-balancer"

  project_name               = var.app_project_name
  cloud_run_service_name_ui  = module.cloud_run_ui_service.cloud_run_service_name
  cloud_run_service_name_api = module.cloud_run_api_service.cloud_run_service_name
  domains                    = var.domains
  gcp_region                 = var.gcp_region
  environment                = var.environment
}

module "notifications" {
  source = "../shared/gcp-notifications"

  project          = var.app_project_name
  environment      = var.environment
  alert_recipients = var.alert_recipients
}

module "monitoring_dashboard" {
  source = "../shared/gcp-monitoring-dashboard"

  project_name = var.app_project_name
  environment  = var.environment
}
