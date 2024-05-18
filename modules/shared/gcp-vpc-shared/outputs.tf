output "host_vpc_name" {
  description = "host vpc name"
  value       = google_compute_network.vpc.name
}
