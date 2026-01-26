#!/bin/bash
set -e

cd "$(dirname "$0")/../terraform"

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
}' > ../ansible/inventory/hosts.yml