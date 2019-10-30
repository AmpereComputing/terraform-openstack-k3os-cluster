# OpenStack KeyPair
resource "openstack_compute_keypair_v2" "terraform" {
  name       = "terraform"
  public_key = "${file("${var.ssh_key_file}.pub")}"
}

# Create a volume for Attached Storage
#resource "openstack_blockstorage_volume_v2" "block_vol" {
#  count = "${var.count}"
#  name = "tf_vol_${count.index}"
#  size = 10
#}

resource "openstack_compute_instance_v2" "vm" {
  count = "${var.count}"
  name = "${format("${var.instance_prefix}-%02d", count.index+1)}"
  image_name = "${var.image}"
  flavor_name = "${var.flavor}"
  key_pair = "${openstack_compute_keypair_v2.terraform.name}"
  security_groups = ["default"]
  network {
    name = "${var.network_name}"
  }
}

# Show Instanace IP Address
output "IPv4 instance v2" {
  value = "${openstack_compute_instance_v2.vm.*.access_ip_v4}"
}

# Attach Storage to Instance
#resource "openstack_compute_volume_attach_v2" "attached" {
#  instance_id = "${openstack_compute_instance_v2.vm.*.id[count.index]}"
#  volume_id = "${openstack_blockstorage_volume_v2.block_vol.*.id[count.index]}"
#}

# Create Floating IPs
resource "openstack_networking_floatingip_v2" "fip" {
  count = "${var.count}"
  pool = "${var.pool}"
}

# Associate Floating IPs to VM Instances
resource "openstack_compute_floatingip_associate_v2" "fip" {
  count       = "${var.count}"
  instance_id = "${openstack_compute_instance_v2.vm.*.id[count.index]}"
  floating_ip = "${openstack_networking_floatingip_v2.fip.*.address[count.index]}"
}

# Show floating IP
output "Floating IPv4 instance v2" {
  value = "${openstack_networking_floatingip_v2.fip.*.address}"
}
