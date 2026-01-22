variable "yc_token" {
  description = "OAuth-токен или IAM-токен для доступа к Yandex Cloud"
  type        = string
}

variable "yc_cloud_id" {
  description = "ID облака"
  type        = string
}

variable "yc_folder_id" {
  description = "ID каталога"
  type        = string
}

variable "ssh_pub_key" {
  description = "Публичный SSH-ключ для доступа к ВМ"
  type        = string
}