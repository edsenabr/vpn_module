variable "vpn_cidr" {
  description = "Subnet CIDR to provide to VPN Clients"
  default = "192.168.1.0/24"
}

variable "vpc_cidr" {
  description = "Subnet CIDR to attach nodes to"
}

variable "vpc" {
  description = "VPC to create the VM"
}


variable "availability_zone" {
  description = "Availabity zone to use"
  type    = string
}

variable "project_id" {
  description = "ID of the project to deploy the VM"
  type    = string
}

variable "subnet_id" {
  description = "Subnet to deploy the VM"
  type    = string
}

variable "region" {
  description = "Region to deploy to"
  type    = string
}

variable "allowed_ips" {
  description = "Access to the endpoints will be restricted to this public IP address"
  type    = list(string)
  default = []
}

variable "vm_machine_type" {
  description = "Shape to be used on the VM"
  type    = string
  default = "e2-micro"
}