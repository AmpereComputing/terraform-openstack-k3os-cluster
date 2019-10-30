variable "region" {
  description = "The the OpenStack region to deploy the network into."
  default = "RegionOne"
}

variable "image" {
  description = "The the OpenStack VM Image to default to when starting multiple virtual machines with terraform"
  default  = "k3os-arm64"
}

variable "flavor" {
  description = "The the OpenStack VM flavor to default to when starting multiple virtual machines with terraform"
  default = "2"
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

variable "count" {
  default = 3
}

variable "network_name" {
  default = "demo-net"
}

variable "instance_prefix" {
  default = "k3OS-"
}
