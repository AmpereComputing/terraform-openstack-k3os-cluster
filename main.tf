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
    content = tls_private_key.k3os.private_key_pem
    filename = "${path.module}/k3os-id_rsa"
    file_permission = "0600"
}

resource "local_file" "k3os-ssh-pubkey" {
    content  = tls_private_key.k3os.public_key_openssh
    filename = "${path.module}/k3os-id_rsa.pub"
    file_permission = "0644"
}

output "k3os_ssh_pubic_key" {
  value = tls_private_key.k3os.public_key_openssh
}

output "k3os_ssh_private_key" {
  value = tls_private_key.k3os.private_key_pem
}


resource "random_uuid" "cluster" { }

# Removing due to adding permissions to the local_file
#resource "null_resource" "key_permissions" {
#  provisioner "local-exec" {
#    command = "chmod 0600 ${path.module}/k3os-id_rsa"
#  }
#}
