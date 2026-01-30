terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.80"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = "ru-central1-a"
}

data "yandex_compute_image" "ubuntu_2204" {
  folder_id = "standard-images"
  family    = "ubuntu-2204-lts"
}

resource "yandex_vpc_network" "pg-network" {
  name = "pg-network"
}

resource "yandex_vpc_subnet" "pg-subnet" {
  name           = "pg-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.pg-network.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

resource "yandex_vpc_security_group" "pg-sg" {
  name        = "pg-security-group"
  network_id  = yandex_vpc_network.pg-network.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 5432
    v4_cidr_blocks = ["10.0.1.0/24"]
  }

  ingress {
    protocol       = "TCP"
    port           = 2379
    v4_cidr_blocks = ["10.0.1.0/24"]
  }

  ingress {
    protocol       = "TCP"
    port           = 2380
    v4_cidr_blocks = ["10.0.1.0/24"]
  }

  ingress {
    protocol       = "TCP"
    port           = 8008
    v4_cidr_blocks = ["10.0.1.0/24"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_compute_instance" "pg" {
  count = 3

  name        = "pg-node-${count.index + 1}"
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204.id
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.pg-subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.pg-sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_pub_key}"
  }

  scheduling_policy {
    preemptible = false
  }
}

resource "yandex_storage_bucket" "pg_backups" {
  bucket    = "pg-backups-${var.yc_folder_id}"
  folder_id = var.yc_folder_id
}