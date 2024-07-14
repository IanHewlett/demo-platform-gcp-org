output "host_vpc_name" {
  description = "host vpc name"
  value       = google_compute_network.vpc.name
}

output "host_vpc_id" {
  description = "host vpc id"
  value       = google_compute_network.vpc.id
}

output "host_vpc_self_link" {
  description = "host vpc self link"
  value       = google_compute_network.vpc.self_link
}

output "serverless_subnet_name" {
  description = ""
  value       = module.subnets.serverless_subnet_name
}
