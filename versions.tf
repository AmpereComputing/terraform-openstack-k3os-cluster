
terraform {
  required_version = ">= 0.13"
  required_providers {
    local = {
      source = "hashicorp/local"
    }
    null = {
      source = "hashicorp/null"
    }
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
    random = {
      source = "hashicorp/random"
    }
    template = {
      source = "hashicorp/template"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
}
