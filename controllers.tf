# k3OS HA controllers

# Cloud-Config
data "template_file" "controllers_cloud_config" {
  template = file("${path.module}/templates/controllers-cfg.yaml.tpl")
  vars = {
    tf_ssh_pubkey = tls_private_key.k3os.public_key_openssh
    controller_address = openstack_compute_instance_v2.vm.access_ip_v4
    tf_controller_id = random_uuid.cluster.result
  }
}

output "controllers_cloud_init" {
  value = data.template_file.controllers_cloud_config.rendered
}

resource "openstack_compute_instance_v2" "controllers" {
  count           = 2
  name            = format("k3os-controller-%02d", count.index+1)
  image_name      = var.image
  flavor_name     = var.flavor
  key_pair        = openstack_compute_keypair_v2.terraform.name
  security_groups = ["default"]
  network {
    name = var.network_name
  }
  user_data    = data.template_file.controllers_cloud_config.rendered
}

# Show Instanace IP Address
output "controllers_ip_internal" {
  value = openstack_compute_instance_v2.controllers.*.access_ip_v4
}
