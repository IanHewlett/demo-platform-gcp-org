module "storage_bucket_upload" {
  source = "../shared/gcp-storage-bucket"

  bucket_name_prefix = "proto-legion"
  bucket_name        = "upload"
  environment        = var.environment
  project            = data.google_project.app_project.name
  region             = var.gcp_region
  storage_class      = "STANDARD"
  versioning         = false

  storageLegacyBucketReaders = [
    module.file_service_service_account.sa_member,
    module.api_service_service_account.sa_member
  ]
  storageObjectViewers = [
    module.file_service_service_account.sa_member
  ]
  storageObjectUsers = []
  storageObjectAdmins = [
    module.api_service_service_account.sa_member
  ]
  storageAdmins = []
}

module "storage_bucket_output" {
  source = "../shared/gcp-storage-bucket"

  bucket_name_prefix = "proto-legion"
  bucket_name        = "output"
  environment        = var.environment
  project            = data.google_project.app_project.name
  region             = var.gcp_region
  storage_class      = "STANDARD"
  versioning         = false

  storageLegacyBucketReaders = [
    module.file_service_service_account.sa_member
  ]
  storageObjectViewers = []
  storageObjectUsers = concat(
    var.storage_users,
    [module.file_service_service_account.sa_member]
  )
  storageObjectAdmins = []
  storageAdmins       = []
}

module "storage_bucket_reject" {
  source = "../shared/gcp-storage-bucket"

  bucket_name_prefix = "proto-legion"
  bucket_name        = "reject"
  environment        = var.environment
  project            = data.google_project.app_project.name
  region             = var.gcp_region
  storage_class      = "STANDARD"
  versioning         = false

  storageLegacyBucketReaders = []
  storageObjectViewers       = []
  storageObjectUsers         = var.storage_users
  storageObjectAdmins        = []
  storageAdmins              = []
}

module "storage_bucket_archive" {
  source = "../shared/gcp-storage-bucket"

  bucket_name_prefix = "proto-legion"
  bucket_name        = "archive"
  environment        = var.environment
  project            = data.google_project.app_project.name
  region             = var.gcp_region
  storage_class      = "STANDARD"
  versioning         = true

  storageLegacyBucketReaders = [
    module.api_service_service_account.sa_member
  ]
  storageObjectViewers = [
    module.api_service_service_account.sa_member
  ]
  storageObjectUsers  = []
  storageObjectAdmins = []
  storageAdmins       = []
}

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

  project_name           = data.google_project.app_project.name
  gcp_region             = var.gcp_region
  allocated_ip_range     = var.allocated_ip_range
  db_tier                = "db-custom-1-3840"
  environment            = var.environment
  api_service_account    = module.api_service_service_account.email
  shared_network_project = var.host_vpc
}

module "load_balancer" {
  source = "../shared/gcp-load-balancer"

  project_name               = data.google_project.app_project.name
  cloud_run_service_name_ui  = module.cloud_run_ui_service.cloud_run_service_name
  cloud_run_service_name_api = module.cloud_run_api_service.cloud_run_service_name
  domains                    = var.domains
  gcp_region                 = var.gcp_region
  environment                = var.environment
  oauth_brand                = "projects/${data.google_project.app_project.number}/brands/${data.google_project.app_project.number}"
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

module "workflow" {
  source = "../shared/gcp-workflow"

  project_name    = data.google_project.app_project.name
  region          = var.gcp_region
  workflow_sa     = module.workflow_service_account.email
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
