variable "yc_access_key_id" {
  description = "ID ключа доступа сервисного аккаунта"
  type        = string
}

variable "yc_secret_access_key" {
  description = "Секретный ключ сервисного аккаунта"
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