output "instance_ips" {
  value = {
    for i, instance in yandex_compute_instance.pg :
    "pg-node-${i + 1}" => instance.network_interface[0].nat_ip_address
  }
}

output "bucket_name" {
  value = yandex_storage_bucket.pg-backups.bucket
}