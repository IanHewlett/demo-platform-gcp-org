module "storage_bucket_upload" {
  source = "../shared/gcp-storage-bucket"

  bucket_name_prefix = "proto-legion"
  bucket_name        = "upload"
  environment        = var.environment
  project            = var.app_project_name
  region             = var.gcp_region
  storage_class      = "STANDARD"
  versioning         = false

  storageLegacyBucketReaders = [
    "serviceAccount:${module.cloud_run_file_service.service_runner_email}",
    "serviceAccount:${module.cloud_run_api_service.service_runner_email}"
  ]
  storageObjectViewers = [
    "serviceAccount:${module.cloud_run_file_service.service_runner_email}"
  ]
  storageObjectUsers = []
  storageObjectAdmins = [
    "serviceAccount:${module.cloud_run_api_service.service_runner_email}"
  ]
  storageAdmins = []
}

module "storage_bucket_output" {
  source = "../shared/gcp-storage-bucket"

  bucket_name_prefix = "proto-legion"
  bucket_name        = "output"
  environment        = var.environment
  project            = var.app_project_name
  region             = var.gcp_region
  storage_class      = "STANDARD"
  versioning         = false

  storageLegacyBucketReaders = [
    "serviceAccount:${module.cloud_run_file_service.service_runner_email}"
  ]
  storageObjectViewers = []
  storageObjectUsers = concat(
    var.storage_users,
    ["serviceAccount:${module.cloud_run_file_service.service_runner_email}"]
  )
  storageObjectAdmins = []
  storageAdmins       = []
}

module "storage_bucket_reject" {
  source = "../shared/gcp-storage-bucket"

  bucket_name_prefix = "proto-legion"
  bucket_name        = "reject"
  environment        = var.environment
  project            = var.app_project_name
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
  project            = var.app_project_name
  region             = var.gcp_region
  storage_class      = "STANDARD"
  versioning         = true

  storageLegacyBucketReaders = [
    "serviceAccount:${module.cloud_run_api_service.service_runner_email}"
  ]
  storageObjectViewers = [
    "serviceAccount:${module.cloud_run_api_service.service_runner_email}"
  ]
  storageObjectUsers  = []
  storageObjectAdmins = []
  storageAdmins       = []
}

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

module "workflow" {
  source = "../shared/gcp-workflow"

  project_name    = var.app_project_name
  project_number  = "508747128547"
  region          = var.gcp_region
  trigger_buckets = ["proto-legion-sbxdev-upload"]

  service_account_roles = [
    "roles/eventarc.eventReceiver",
    "roles/logging.logWriter",
    "roles/run.invoker",
    "roles/storage.objectUser",
    "roles/workflows.invoker"
  ]
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
