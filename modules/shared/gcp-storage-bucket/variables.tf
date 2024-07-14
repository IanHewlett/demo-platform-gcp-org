variable "environment" {
  type = string
}

variable "project" {
  type        = string
  description = "Google Cloud Project"
}

variable "region" {
  type        = string
  description = "Google Cloud Region"
}

variable "storage_class" {
  type = string
}

variable "versioning" {
  type = bool
}

variable "bucket_name_prefix" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "storageLegacyBucketReaders" {
  type = set(string)
}

variable "storageObjectViewers" {
  type = set(string)
}

variable "storageObjectUsers" {
  type = set(string)
}

variable "storageObjectAdmins" {
  type = set(string)
}

variable "storageAdmins" {
  type = set(string)
}

variable "storageObjectCreators" {
  type = set(string)
}
