data "template_file" "startup_script_config" {
  template = file("${path.module}/templates/startup.tpl")
  vars = {
    bucket = google_storage_bucket.config_files.url
  }
}
resource "google_compute_instance" "vpn_server" {
  project      = var.project_id
  name         = "vpn-server"
  machine_type = var.vm_machine_type
  zone = var.availability_zone
  can_ip_forward = true
  
  tags = ["ssh-from-iap", "vpn"]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    subnetwork = var.subnet_id
    access_config {
      nat_ip = google_compute_address.vpn.address
    }
  }

  metadata = {
    enable-oslogin: "false"
  }

  service_account {
    email  = google_service_account.vpn.email
    scopes = ["cloud-platform"]
  }  

  metadata_startup_script = data.template_file.startup_script_config.rendered
}