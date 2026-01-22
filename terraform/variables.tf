variable "yc_token" {
  description = "IAM-токен пользователя для управления ВМ"
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
  description = "Публичный SSH-ключ"
  type        = string
}