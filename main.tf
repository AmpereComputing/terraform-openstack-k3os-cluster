# OpenStack KeyPair
resource "openstack_compute_keypair_v2" "terraform" {
  name       = "terraform"
  public_key = file("${var.ssh_key_file}.pub")
}

resource "tls_private_key" "k3os" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "k3os-ssh-privkey" {
    content = "${tls_private_key.k3os.private_key_pem}"
    filename = "${path.module}/k3os-id_rsa"
}

resource "local_file" "k3os-ssh-pubkey" {
    content  = "${tls_private_key.k3os.public_key_openssh}"
    filename = "${path.module}/k3os-id_rsa.pub"
}

output "k3os_ssh_pubic_key" {
  value = "${tls_private_key.k3os.public_key_openssh}"
}

output "k3os_ssh_private_key" {
  value = "${tls_private_key.k3os.private_key_pem}"
}


resource "random_id" "cluster" {
  keepers = {
    # Generate a new string to be used for the cluster authentication
    master_id = "${var.master_id}"
  }

  byte_length = 8
}

