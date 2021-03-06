
resource "null_resource" "get_kubeconfig_from_master" {
  triggers = {
    controller_id = openstack_compute_instance_v2.vm.id
  }
  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${local_file.k3os-ssh-privkey.filename} rancher@${openstack_networking_floatingip_v2.fip.address}:/etc/rancher/k3s/k3s.yml ~/.kube/config"
  }
}
