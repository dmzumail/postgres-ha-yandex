#!/bin/bash
set -e

ROOT_DIR="$(dirname "$(realpath "$0")")/.."
mkdir -p "$ROOT_DIR/ansible/inventory"
cd "$ROOT_DIR/terraform"

# Получаем публичные и внутренние IP
PG1_PUBLIC=$(terraform output -json instance_ips | jq -r '.["pg-node-1"]')
PG2_PUBLIC=$(terraform output -json instance_ips | jq -r '.["pg-node-2"]')
PG3_PUBLIC=$(terraform output -json instance_ips | jq -r '.["pg-node-3"]')

PG1_INTERNAL=$(terraform output -json instance_internal_ips | jq -r '.["pg-node-1"]')
PG2_INTERNAL=$(terraform output -json instance_internal_ips | jq -r '.["pg-node-2"]')
PG3_INTERNAL=$(terraform output -json instance_internal_ips | jq -r '.["pg-node-3"]')

cat > "$ROOT_DIR/ansible/inventory/hosts.yml" << EOF
postgresql:
  hosts:
    pg-node-1:
      ansible_host: $PG1_PUBLIC
      internal_ip: $PG1_INTERNAL
      etcd_name: node1
    pg-node-2:
      ansible_host: $PG2_PUBLIC
      internal_ip: $PG2_INTERNAL
      etcd_name: node2
    pg-node-3:
      ansible_host: $PG3_PUBLIC
      internal_ip: $PG3_INTERNAL
      etcd_name: node3
  vars:
    ansible_user: ubuntu
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
EOF

echo "Inventory generated at $ROOT_DIR/ansible/inventory/hosts.yml"