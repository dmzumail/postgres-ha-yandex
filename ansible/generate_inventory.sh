#!/bin/bash
set -e

# Определяем корневую директорию проекта
ROOT_DIR="$(dirname "$(realpath "$0")")/.."

# Создаём папку inventory, если её нет
mkdir -p "$ROOT_DIR/ansible/inventory"

# Переходим в папку terraform
cd "$ROOT_DIR/terraform"

# Генерируем hosts.yml из вывода Terraform
terraform output -json instance_ips | jq -r '
{
  all: {
    children: {
      postgres_ha: {
        hosts: (to_entries | map({
          (.key): {
            ansible_host: .value,
            etcd_name: (.key | sub("pg-node-"; "node"))
          }
        }) | add)
      }
    },
    vars: {
      ansible_user: "ubuntu",
      ansible_ssh_private_key_file: "~/.ssh/id_rsa"
    }
  }
}' > "$ROOT_DIR/ansible/inventory/hosts.yml"

echo "Inventory generated at $ROOT_DIR/ansible/inventory/hosts.yml"