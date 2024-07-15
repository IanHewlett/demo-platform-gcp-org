output "host_vpc_name" {
  description = "host vpc name"
  value       = module.shared_vpc.host_vpc_name
}

output "host_vpc_id" {
  description = "host vpc id"
  value       = module.shared_vpc.host_vpc_id
}

output "host_vpc_self_link" {
  description = "host vpc self link"
  value       = module.shared_vpc.host_vpc_self_link
}
