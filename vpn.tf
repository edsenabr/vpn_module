data "template_file" "startup_script_config" {
  template = file("${path.module}/templates/startup.tpl")
  vars = {
    bucket = google_storage_bucket.config_files.url
  }
}

resource "random_uuid" "vpn" {
}

data "template_file" "vpn_config" {
  template = file("${path.module}/templates/VPN.nmconnection.tpl")
  vars = {
    ca_cert = local_file.ca_cert.filename
    user = "edsena" ##TODO: get current user
    client_cert = local_file.client_cert.filename
    client_key = local_file.client_key.filename
    vpn_uuid = random_uuid.vpn.result
  }
}

resource "local_file" "vpn_config" {
  content  = data.template_file.vpn_config
  filename = "${path.root}/VM.nmconnection"
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
    startup-script: data.template_file.startup_script_config.rendered
  }

  service_account {
    email  = google_service_account.vpn.email
    scopes = ["cloud-platform"]
  }  

  # metadata_startup_script = data.template_file.startup_script_config.rendered
}