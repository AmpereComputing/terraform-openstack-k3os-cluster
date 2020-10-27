# k3OS controller

data "template_file" "controller_cloud_config" {
  template = file("${path.module}/templates/controller-cfg.yaml.tpl")
  vars = {
    tf_ssh_privkey = tls_private_key.k3os.private_key_pem
    tf_ssh_pubkey = tls_private_key.k3os.public_key_openssh
    tf_controller_id = random_uuid.cluster.result
  }
}

output "controller_cloud_init" {
  value = data.template_file.controller_cloud_config.rendered
}




resource "openstack_compute_instance_v2" "vm" {
# count           = var.controller_count
  name            = "k3os-controller"
  image_name      = var.image
  flavor_name     = var.flavor
  key_pair        = openstack_compute_keypair_v2.terraform.name
  security_groups = ["default"]
  network {
    name = var.network_name
  }
  # user_data = "${file("${path.module}/templates/controller-cfg.yaml")}"
  user_data    = data.template_file.controller_cloud_config.rendered
}

# Show Instanace IP Address
output "controller_ip_internal" {
  value = openstack_compute_instance_v2.vm.*.access_ip_v4
}

# Create Floating IPs
resource "openstack_networking_floatingip_v2" "fip" {
#  count = var.controller_count
  pool = var.pool
}

# Associate Floating IPs to VM Instances
resource "openstack_compute_floatingip_associate_v2" "fip" {
#  count       = var.controller_count
#  instance_id = "${openstack_compute_instance_v2.vm.*.id[count.index]}"
  instance_id = openstack_compute_instance_v2.vm.id
#  floating_ip = "${openstack_networking_floatingip_v2.fip.*.address[count.index]}"
  floating_ip = openstack_networking_floatingip_v2.fip.address
}

# Show floating IP
output "controller_ip_external" {
  value = openstack_networking_floatingip_v2.fip.*.address
}
