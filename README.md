![Ampere Computing](https://avatars2.githubusercontent.com/u/34519842?s=400&u=1d29afaac44f477cbb0226139ec83f73faefe154&v=4)

# terraform-openstack-k3os-cluster


[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)


## Description

This Terraform will build a multinode (ARM64/AMD64) k3OS cluster with a single master and N+1 minions. Minions join the Master node upon boot. The IP address of the master node is rendered dynamically in the cloud-config template used to launch the Minons. Minion count is configurable via the `minion_count` variable located in variables.tf

## Quickstart

```

git clone https://github.com/amperecomputing/terraform-openstack-k3os-cluster
cd terraform-openstack-k3os-cluster
terraform init && terraform plan && terraform apply -auto-approve
```

## k3OS Packer Image Template

* The k3OS image used is created via a packer tempate.
* The packer image template is located in the k3OS source here: [https://github.com/rancher/k3os](https://github.com/rancher/k3os)
* The base image is created using using an Ubuntu 18.04 (ARM64/AMD64) image.
* An Ubuntu 18.04 image must be present in Glance prior to building the image.
* Terraform was used to deploy the Ubuntu 18.04 image to OpenStack. The Terraform code for loading images can be found [here](https://github.com/amperecomputing/terraform-openstack-images).
* Assuming kolla-ansible was used to deploy openstack and packer is run from the kolla-ansible control node the following should build the packer image:

```
git clone https://github.com/rancher/k3os
cd k3os/package/packer/openstack
source /etc/kolla/admin-openrc.sh
export OS_SOURCE_IMAGE=`openstack image list | grep 'ubuntu-18.04'| awk '{print $2}'`
export OS_NETWORKS_ID=`openstack network list | grep 'demo-net'| awk '{print $2}'`
export OS_FLOATING_IP_POOL='public1'
packer validate template-arm64.json
packer build template-arm64.json
```
## Notes

* Currently there is a bug in the overlay installation of k3OS which causes the VM using the image to shutdown after first boot.  
* A pull request exists with a fix but is not slated for merge until the next point release of k3OS.
* When starting the cluster, all the nodes will be created then get powered down as a result.
* Until the next point release of k3OS, you will have to manually turn on the instances after creation.
* I suggests powering them on one at a time starting with master.
* If logged into the master while the other instances are being powered on, you can watch them join the cluster with the following command:

```
watch -n1 kubectl get nodes -o wide

```




