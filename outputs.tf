############Output############################################
output "vpn_server_ssh" {
  value       = "gcloud compute ssh --project ${var.project_id} --tunnel-through-iap --zone ${google_compute_instance.vpn_server.zone} ${google_compute_instance.vpn_server.name}"
  description = "SSH command to login into the VPN Server"
}

output "vpn_server_ip" {
  value       = google_compute_instance.vpn_server.network_interface[0].access_config[0].nat_ip
  description = "SSH Server Public IP"
}