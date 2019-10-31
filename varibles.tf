variable "region" {
  description = "The the OpenStack region to deploy the network into."
  default     = "RegionOne"
}

variable "image" {
  description = "The the OpenStack VM Image to default to when starting multiple virtual machines with terraform"
  default     = "k3OS-v0.5.0-arm64"
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
  default = "public1"
}

variable "network_name" {
  default = "demo-net"
}

variable "instance_prefix" {
  default = "k3os-minon"
}

variable "master_count" {
  default = 1
}
variable "minion_count" {
  default = 3
}
