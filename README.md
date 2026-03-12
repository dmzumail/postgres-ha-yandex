# PostgreSQL HA Cluster with Patroni + etcd on Yandex Cloud

[![CI - Validate Configuration](https://github.com/dmzumail/postgres-ha-yandex/actions/workflows/ci.yml/badge.svg)](https://github.com/dmzumail/postgres-ha-yandex/actions/workflows/ci.yml)
![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.6.0-blue)
![Ansible](https://img.shields.io/badge/Ansible-%3E%3D2.14-red)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue)

> 🚀 Production-ready решение для развёртывания отказоустойчивого кластера PostgreSQL в Yandex Cloud (Patroni + etcd) с автоматическим failover и бэкапами в S3.

---

## 💻 Технологический стек

- **IaC**: Terraform + Yandex Cloud Provider
- **Config Management**: Ansible
- **OS**: Ubuntu 22.04 LTS
- **HA**: Patroni + etcd (DCS)
- **Backups**: WAL-G → Yandex Object Storage
- **CI/CD**: GitHub Actions

---

## 📦 Требования

- **Локально**: `terraform`, `ansible`, `jq`, `python3-pip`
- **Yandex Cloud**: IAM-токен, права на создание VPC/VM, SSH-ключи
- **Python**: `pip3 install 'patroni[etcd]' psycopg2-binary yandexcloud`

---

## ⚙️ Конфигурация

### Структура проекта

<img width="511" height="171" alt="{25B1586D-3263-44C3-9034-377B6333F66E}" src="https://github.com/user-attachments/assets/fce63658-ef05-498c-9d7c-0d728ad88126" />




## 🔐 Безопасность и Бэкапы

- **Доступ**: SSH по ключам, порты БД закрыты Security Groups (только внутри подсети).
- **Секреты**: Хранятся в Ansible Vault.
- **Бэкапы**: WAL-G архивирует WAL в Yandex Object Storage (S3).

---

## 📄 Лицензия

MIT

🔗 **Документация**: [Patroni](https://patroni.readthedocs.io/) | [Yandex Terraform](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs)
