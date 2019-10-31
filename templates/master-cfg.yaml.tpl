ssh_authorized_keys:
- github:ppouliot
write_files:
- encoding: ""
  content: |-
    #!/bin/bash
    echo "Downloading and Installing RIO"
    curl -sfL https://get.rio.io | sh -
    #while ! kubectl cluster-info >/dev/null 2>&1; do
    #  sleep 1
    #done
    #rio install
  owner: root
  path: /etc/local.d/01_install_rio.sh
  permissions: '0755'
- encoding: ""
  content: |-
    #!/bin/bash
    echo "Installing OpenFAAS Client"
    curl -sL https://cli.openfaas.com | sh
  owner: root
  path: /etc/local.d/02_install_faascli.sh
  permissions: '0755'
- encoding: ""
  content: |-
    #!/bin/bash
    echo "Installing OpenFAAS"
    while ! kubectl cluster-info >/dev/null 2>&1; do
      sleep 1
    done
    kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml
  owner: root
  path: /etc/local.d/03_install_faas.sh
  permissions: '0755'
run_cmd:
- 'sh /etc/local.d/01_install_rio.sh'
- 'sh /etc/local.d/02_install_faascli.sh'
#- 'sh /etc/local.d/03_install_faas.sh'
k3os:
  data_sources:
  - openstack
  dns_nameservers:
  - 1.1.1.1
  ntp_servers:
  - 0.us.pool.ntp.org
  - 1.us.pool.ntp.org
  token: "Amp3r3C0mput1ngk30SClust2r"
