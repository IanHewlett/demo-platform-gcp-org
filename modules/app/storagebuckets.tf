module "storage_bucket_upload" {
  source = "../shared/gcp-storage-bucket"

  bucket_name_prefix = var.bucket_prefix
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

  storageObjectCreators = []
}

module "storage_bucket_output" {
  source = "../shared/gcp-storage-bucket"

  bucket_name_prefix = var.bucket_prefix
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

  storageAdmins = []

  storageObjectCreators = []
}

module "storage_bucket_reject" {
  source = "../shared/gcp-storage-bucket"

  bucket_name_prefix = var.bucket_prefix
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
  storageObjectCreators      = []
}

module "storage_bucket_archive" {
  source = "../shared/gcp-storage-bucket"

  bucket_name_prefix = var.bucket_prefix
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

  storageObjectUsers    = []
  storageObjectAdmins   = []
  storageAdmins         = []
  storageObjectCreators = []
}
