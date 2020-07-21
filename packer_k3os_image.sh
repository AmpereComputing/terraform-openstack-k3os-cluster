#!/usr/bin/env bash

PROJECT_DIR=`pwd`
#LOGFILE=${PROJECT_DIR}/k3OS_packer_image.log
#exec >> $LOGFILE 2>&1

# This Assumes OpenStack was installed with kolla and it was configured with a default init-runonce
source /etc/kolla/admin-openrc.sh
export OS_SOURCE_IMAGE=`openstack image list | grep 'ubuntu-18.04'| awk '{print $2}'`
export OS_NETWORKS_ID=`openstack network list | grep 'demo-net'| awk '{print $2}'`
export OS_FLOATING_IP_POOL='public1'

echo $OS_SOURCE_IMAGE
echo $OS_NETWORKS_ID
echo $OS_FLOATING_IP_POOL

cd /opt
git clone https://github.com/rancher/k3os
cd /opt/k3os/package/packer/openstack
packer validate template-arm64.json
packer build template-arm64.json
