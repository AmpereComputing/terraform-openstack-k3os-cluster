# k3OS minion

variable "master_address" {
  default = ""
}

# Cloud-Config
data "template_file" "minion_cloud_config" {
  template = "${file("${path.module}/templates/minion-cfg.yaml.tpl")}"
  vars = {
    tf_ssh_pubkey = "${tls_private_key.k3os.public_key_openssh}"
    master_address = "${openstack_compute_instance_v2.vm.access_ip_v4}"
    master_id = "${var.master_id}"
  }
}

output "minion_cloud_init" {
  value = "${data.template_file.minion_cloud_config.rendered}"
}



resource "openstack_compute_instance_v2" "minion" {
  count           = var.minion_count
  name            = "${format("${var.instance_prefix}-%02d", count.index+1)}"
  image_name      = var.image
  flavor_name     = var.flavor
  key_pair        = openstack_compute_keypair_v2.terraform.name
  security_groups = ["default"]
  network {
    name = var.network_name
  }
  user_data    = "${data.template_file.minion_cloud_config.rendered}"
}

# Show Instanace IP Address
output "minion_ip_internal" {
  value = "${openstack_compute_instance_v2.minion.*.access_ip_v4}"
}

# Create Floating IPs
#resource "openstack_networking_floatingip_v2" "floating_ip_minion" {
#  count = var.master_count
#  pool = var.pool
#}

# Associate Floating IPs to VM Instances
#resource "openstack_compute_floatingip_associate_v2" "floating_ip_minion" {
#  count       = var.master_count
#  instance_id = "${openstack_compute_instance_v2.minion.*.id[count.index]}"
#  floating_ip = "${openstack_networking_floatingip_v2.floating_ip_minion.*.address[count.index]}"
#}

# Show floating IP
#output "minion_ip_external" {
#  value = "${openstack_networking_floatingip_v2.floating_ip_minion.*.address}"
#}
