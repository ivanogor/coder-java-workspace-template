variable "namespace" {
  description = "Kubernetes namespace for student workspaces"
  type        = string
  default     = "coder-workspaces"
}

variable "workspace_image" {
  description = "Docker image used for student workspace"
  type        = string
  default     = "coder-java-workspace:dev"
}

variable "cpu_request" {
  description = "Requested CPU for workspace"
  type        = string
  default     = "500m"
}

variable "cpu_limit" {
  description = "Maximum CPU for workspace"
  type        = string
  default     = "2"
}

variable "memory_request" {
  description = "Requested memory for workspace"
  type        = string
  default     = "1Gi"
}

variable "memory_limit" {
  description = "Maximum memory for workspace"
  type        = string
  default     = "3Gi"
}

variable "storage_size" {
  description = "Persistent storage size for workspace"
  type        = string
  default     = "5Gi"
}

variable "storage_class_name" {
  description = "Kubernetes StorageClass used for workspace PVC"
  type        = string
  default     = null
  nullable    = true
}

variable "code_server_port" {
  description = "Port used by code-server inside workspace"
  type        = number
  default     = 13337
}