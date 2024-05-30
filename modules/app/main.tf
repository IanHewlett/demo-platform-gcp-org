module "app_project" {
  source = "../shared/gcp-project"

  billing_account_id = var.billing_account_id
  folder_id          = var.app_folder_id
  project_name       = var.app_project_name
  project_services   = var.app_services
  jit_services       = var.jit_services
}

resource "google_service_account" "app_service_account" {
  account_id   = "terraform-sa-${module.app_project.name}"
  display_name = "Terraform-managed."
  description  = "Privileged Terraform service account for app project"
  project      = module.app_project.name
}

resource "google_project_iam_member" "app_project_iam_additive" {
  for_each = var.app_roles

  project = module.app_project.name
  role    = each.key
  member  = "serviceAccount:${google_service_account.app_service_account.email}"
}

module "vpc_service_project" {
  source = "../shared/gcp-vpc-service-project"

  project_name     = module.app_project.name
  project_number   = module.app_project.number
  gcp_region       = var.gcp_region
  host_vpc         = var.host_vpc
  app_subnet_cidr  = var.app_subnet_cidr
  project_sa_email = google_service_account.app_service_account.email
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

module "monitoring_dashboard" {
  source = "../shared/gcp-monitoring-dashboard"

  project_name = module.app_project.name
  environment  = var.environment
}
