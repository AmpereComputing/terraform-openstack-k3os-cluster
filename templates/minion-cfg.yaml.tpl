#cloud-config
ssh_authorized_keys:
- ${tf_ssh_pubkey}
- github:ppouliot
k3os:
  data_sources:
  - openstack
  dns_nameservers:
  - 1.1.1.1
  ntp_servers:
  - 0.us.pool.ntp.org
  - 1.us.pool.ntp.org
  token: "${var.master_id}"
  server_url: https://${master_address}:6443
