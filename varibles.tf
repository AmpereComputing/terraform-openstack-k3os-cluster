variable "region" {
  description = "The the OpenStack region to deploy the network into."
  default     = "RegionOne"
}

variable "image" {
  description = "The the OpenStack VM Image to default to when starting multiple virtual machines with terraform"
  default     = "k3OS-v0.9.0-arm64"
}

variable "flavor" {
  description = "The the OpenStack VM flavor to default to when starting multiple virtual machines with terraform"
  default     = "m1.medium"
}

variable "ssh_key_file" {
  default = "~/.ssh/id_rsa"
}

variable "ssh_user_name" {
  default = "rancher"
}

variable "pool" {
  description = "OpenStack floating ip pool name"
  default = "public1"
}

variable "network_name" {
  description = "OpenStack network name"
  default = "demo-net"
}

variable "instance_prefix" {
  description = "Name prefix for vm instances"
  default = "k3os-minon"
}

variable "master_count" {
  # Currently on one master
  default = 1
}
variable "minion_count" {
  # How many minions do you want?
  default = 7
}

variable "master_address" {
  default = ""
}
