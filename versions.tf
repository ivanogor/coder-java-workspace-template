terraform {
  required_version = ">= 1.16.0"

  required_providers {
    coder = {
      source  = "coder/coder"
      version = "~> 2.18"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.2"
    }
  }
}