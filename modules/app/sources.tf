locals {
  http_sources = [
    {
      name   = "sensible-utils_0.0.17+nmu1_all.deb"
      sha256 = "e0e66f783996ec4670ed5041c446160ec671c723d4be47d3bc27af93c2958a76"
      url    = "http://deb.debian.org/debian/pool/main/s/sensible-utils/sensible-utils_0.0.17%2bnmu1_all.deb"
    },
    {
      name   = "perl_5.36.0-7+deb12u1_amd64.deb"
      sha256 = "95224197cc1275ee3e625be4522f9d03f8fea3bd7a5d7d8f1f55ab914736b404"
      url    = "http://deb.debian.org/debian/pool/main/p/perl/perl_5.36.0-7%2bdeb12u1_amd64.deb"
    },
    {
      name   = "postgresql-client-common_248_all.deb"
      sha256 = "da9a9f21d23d29a5a0aaf38083705a2b3528682c338006a2c14d1421c9ec88dd"
      url    = "http://deb.debian.org/debian/pool/main/p/postgresql-common/postgresql-client-common_248_all.deb"
    },
    {
      name   = "install-info_6.8-6+b1_amd64.deb"
      sha256 = "015b1986fd8a2dc8e37fe8cddffe6263750bcecce7946dc4df80eff940dfe900"
      url    = "http://deb.debian.org/debian/pool/main/t/texinfo/install-info_6.8-6%2bb1_amd64.deb"
    },
    {
      name   = "libpq5_15.7-0+deb12u1_amd64.deb"
      sha256 = "78c33c472d48be2b26b7f51efe1eaf1bcf597f9da8afa5278ce638eadc6d65d4"
      url    = "http://deb.debian.org/debian/pool/main/p/postgresql-15/libpq5_15.7-0%2bdeb12u1_amd64.deb"
    },
    {
      name   = "postgresql-client-15_15.7-0+deb12u1_amd64.deb"
      sha256 = "785a7df4c016d7a66bf46e57c93cb541dc5c2c0c79a76c83259a51c6d76b5083"
      url    = "http://deb.debian.org/debian/pool/main/p/postgresql-15/postgresql-client-15_15.7-0%2bdeb12u1_amd64.deb"
    },
    {
      name   = "postgresql-client_15+248_all.deb"
      sha256 = "3c16150d75e91e4a9662b80059da3c6a0cac16d806d1556efcb476329bc8561f"
      url    = "http://deb.debian.org/debian/pool/main/p/postgresql-common/postgresql-client_15%2b248_all.deb"
    },
    {
      name   = "cloud-sql-proxy.linux.amd64"
      sha256 = "b966551f20c4a669dea521c31b796d0192873ebbdaf719c3d4c38ad569974207"
      url    = "https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.11.4/cloud-sql-proxy.linux.amd64"
    },
    {
      name   = "google-cloud-ops-agent_2.48.0~debian12_amd64.deb"
      sha256 = "d459c9dcf6bb6610363020e90b967008d84537955a02d400f2fd0f789f84bb6e"
      url    = "https://packages.cloud.google.com/apt/pool/google-cloud-ops-agent-bookworm-all/google-cloud-ops-agent_2.48.0%7edebian12_amd64_7020e9d3cb7696e50d43b5a8b06d7429.deb"
    }
  ]
}

module "storage_bucket_package_sources" {
  source = "../shared/gcp-storage-bucket"

  bucket_name_prefix = var.bucket_prefix
  bucket_name        = "package-sources"
  environment        = var.environment
  project            = var.app_project_name
  region             = var.gcp_region
  storage_class      = "STANDARD"
  versioning         = false

  storageLegacyBucketReaders = []
  storageObjectViewers       = []

  storageObjectUsers = [
    module.bastion_host_service_account.sa_member
  ]

  storageObjectAdmins = []
  storageAdmins       = []
}

resource "null_resource" "download_source" {
  for_each = { for idx, source in local.http_sources : idx => source }

  triggers = {
    name   = each.value.name
    sha256 = each.value.sha256
    url    = each.value.url
  }

  provisioner "local-exec" {
    command     = "curl -sL ${each.value.url} -o ${each.value.name}"
    interpreter = ["/bin/sh", "-c"]
    on_failure  = fail
  }
}

resource "google_storage_bucket_object" "source" {
  for_each = { for idx, source in local.http_sources : idx => source }

  name   = each.value.name
  source = "${path.module}/${each.value.name}"
  bucket = module.storage_bucket_package_sources.name

  depends_on = [
    null_resource.download_source,
  ]

  lifecycle {
    ignore_changes = [
      detect_md5hash,
    ]
  }
}
