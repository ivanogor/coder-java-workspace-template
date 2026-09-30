# Coder Java Workspace Template

Базовый workspace template для проекта «Серверная среда разработки для студентов ИРГУПС».

Template предназначен для запуска индивидуальной Java-среды разработки студента через Coder в Kubernetes/k3s.

## Архитектура

```text
Пользователь
    ↓
Coder
    ↓
Terraform Template
    ↓
k3s / Kubernetes
    ↓
Workspace Pod
├── Coder Agent
├── code-server
├── JDK 21
├── Maven
├── Git
└── PVC → /workspace