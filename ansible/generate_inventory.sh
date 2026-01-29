#!/bin/bash
set -e

ROOT_DIR="$(dirname "$(realpath "$0")")/.."
mkdir -p "$ROOT_DIR/ansible/inventory"
cd "$ROOT_DIR/terraform"

# Получаем IP из instance_ips с помощью jq
PG1=$(terraform output -json instance_ips | jq -r '.["pg-node-1"]')
PG2=$(terraform output -json instance_ips | jq -r '.["pg-node-2"]')
PG3=$(terraform output -json instance_ips | jq -r '.["pg-node-3"]')

cat > "$ROOT_DIR/ansible/inventory/hosts.yml" << EOF
postgresql:
  hosts:
    pg-node-1:
      ansible_host: $PG1
      etcd_name: node1
    pg-node-2:
      ansible_host: $PG2
      etcd_name: node2
    pg-node-3:
      ansible_host: $PG3
      etcd_name: node3
  vars:
    ansible_user: ubuntu
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
EOF

echo "Inventory generated at $ROOT_DIR/ansible/inventory/hosts.yml"