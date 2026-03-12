# PostgreSQL HA Cluster with Patroni + etcd on Yandex Cloud

[![CI - Validate Configuration](https://github.com/dmzumail/postgres-ha-yandex/actions/workflows/ci.yml/badge.svg)](https://github.com/dmzumail/postgres-ha-yandex/actions/workflows/ci.yml)
![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.6.0-blue)
![Ansible](https://img.shields.io/badge/Ansible-%3E%3D2.14-red)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue)

> 🚀 Production-ready решение для развёртывания отказоустойчивого кластера PostgreSQL в Yandex Cloud с автоматическим failover, мониторингом и резервным копированием.

---

## 📋 Оглавление

- [Архитектура](#-архитектура)
- [Технологический стек](#-технологический-стек)
- [Требования](#-требования)
- [Быстрый старт](#-быстрый-старт)
- [Конфигурация](#-конфигурация)
- [CI/CD](#-cicd)
- [Безопасность](#-безопасность)
- [Мониторинг и бэкапы](#-мониторинг-и-бэкапы)
- [Troubleshooting](#-troubleshooting)
- [Вклад в проект](#-вклад-в-проект)

---

## 🏗️ Архитектура
┌─────────────────────────────────────────┐
│ Yandex Cloud (ru-central1) │
├─────────────────────────────────────────┤
│ ┌─────────┐ ┌─────────┐ ┌─────────┐ │
│ │ pg-node-1│ │ pg-node-2│ │ pg-node-3│ │
│ │ │ │ │ │ │ │
│ │ Patroni │ │ Patroni │ │ Patroni │ │
│ │ etcd │ │ etcd │ │ etcd │ │
│ │ PostgreSQL │ PostgreSQL │ PostgreSQL │ │
│ └────┬────┘ └────┬────┘ └────┬────┘ │
│ │ │ │ │
│ ┌────▼────────────▼────────────▼────┐ │
│ │ etcd Cluster (DCS) │ │
│ │ Консенсус для выбора лидера │ │
│ └───────────────────────────────────┘ │
│ │
│ ┌────────────────────────────────┐ │
│ │ Yandex Object Storage (S3) │ │
│ │ WAL-G / pgBackRest бэкапы │ │
│ └────────────────────────────────┘ │
└────────────────────────────────────────┘


### Компоненты:

| Компонент | Назначение | Порт |
|-----------|------------|------|
| **PostgreSQL 15** | Основная СУБД | 5432 |
| **Patroni** | Оркестрация кластера, автоматический failover | 8008 (API) |
| **etcd** | Distributed Configuration Store (DCS) | 2379 (client), 2380 (peer) |
| **Ansible** | Автоматизация настройки и управления | — |
| **Terraform** | Provisioning инфраструктуры в YC | — |
| **WAL-G/pgBackRest** | Резервное копирование в Object Storage | — |

---

## 💻 Технологический стек

- **IaC**: Terraform ≥ 1.6.0 + Yandex Cloud Provider ≥ 0.80
- **Config Management**: Ansible ≥ 2.14 + Jinja2
- **OS**: Ubuntu 22.04 LTS
- **HA**: Patroni + etcd
- **Backups**: WAL-G или pgBackRest → Yandex Object Storage
- **CI/CD**: GitHub Actions (валидация Terraform и Ansible)
- **Secrets**: Ansible Vault + Yandex IAM-токены

---

## 📦 Требования

### Локально:
```bash
# Обязательные утилиты
sudo apt install terraform ansible jq python3-pip sshpass -y

# Python-зависимости для Ansible
pip3 install 'patroni[etcd]' psycopg2-binary yandexcloud
