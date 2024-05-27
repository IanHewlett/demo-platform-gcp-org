module "app_project" {
  source = "../shared/gcp-project-app"

  project_name       = var.app_project_name
  app_roles          = var.app_roles
  app_services       = var.app_services
  billing_account_id = var.billing_account_id
  folder_id          = var.app_folder_id
  host_vpc           = var.host_vpc
  gcp_region         = var.gcp_region
  app_subnet_cidr    = var.app_subnet_cidr
}

module "cloud_run_ui_service" {
  source = "../shared/gcp-cloud-run"

  project_name           = module.app_project.name
  gcp_region             = var.gcp_region
  cloud_run_service_name = "app-ui-service"

  service_account_roles = []
}

module "cloud_run_api_service" {
  source = "../shared/gcp-cloud-run"

  project_name           = module.app_project.name
  gcp_region             = var.gcp_region
  cloud_run_service_name = "app-api-service"

  service_account_roles = [
    "roles/cloudsql.client",
    "roles/cloudsql.viewer",
    "roles/cloudtrace.agent"
  ]
}

module "load_balancer" {
  source = "../shared/gcp-load-balancer"

  project_name               = module.app_project.name
  cloud_run_service_name_ui  = module.cloud_run_ui_service.cloud_run_service_name
  cloud_run_service_name_api = module.cloud_run_api_service.cloud_run_service_name
  domains                    = var.domains
  gcp_region                 = var.gcp_region
  environment                = var.environment
}

module "cloudsql_api" {
  source = "../shared/gcp-cloudsql"

  project_name           = module.app_project.name
  gcp_region             = var.gcp_region
  allocated_ip_range     = var.allocated_ip_range
  db_tier                = "db-custom-1-3840"
  environment            = var.environment
  api_service_account    = module.cloud_run_api_service.service_runner_email
  shared_network_project = var.host_vpc
}

module "notifications" {
  source = "../shared/gcp-notifications"

  project          = module.app_project.name
  environment      = var.environment
  alert_recipients = var.alert_recipients
}
