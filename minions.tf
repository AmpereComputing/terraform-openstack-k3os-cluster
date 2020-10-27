# k3OS minion

# Cloud-Config
data "template_file" "minion_cloud_config" {
  template = file("${path.module}/templates/minion-cfg.yaml.tpl")
  vars = {
    tf_ssh_pubkey = tls_private_key.k3os.public_key_openssh
    master_address = openstack_compute_instance_v2.vm.access_ip_v4
    tf_master_id = random_uuid.cluster.result
  }
}

output "minion_cloud_init" {
  value = data.template_file.minion_cloud_config.rendered
}



resource "openstack_compute_instance_v2" "minion" {
  count           = var.minion_count
  name            = format("${var.instance_prefix}-%02d", count.index+1)
  image_name      = var.image
  flavor_name     = var.flavor
  key_pair        = openstack_compute_keypair_v2.terraform.name
  security_groups = ["default"]
  network {
    name = var.network_name
  }
  user_data    = data.template_file.minion_cloud_config.rendered
}

# Show Instanace IP Address
output "minion_ip_internal" {
  value = openstack_compute_instance_v2.minion.*.access_ip_v4
}
