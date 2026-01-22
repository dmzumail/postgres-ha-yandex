output "instance_ips" {
  value = {
    for i, instance in yandex_compute_instance.pg :
    "pg-node-${i + 1}" => instance.network_interface[0].nat_ip_address
  }
}

output "backup_bucket" {
  value = yandex_storage_bucket.pg_backups.bucket
}