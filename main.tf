provider "coder" {
}

provider "kubernetes" {
}

data "coder_workspace" "me" {
}

data "coder_workspace_owner" "me" {
}

resource "coder_agent" "main" {
  os   = "linux"
  arch = "amd64"

  startup_script = <<-EOT
    #!/bin/bash
    set -e

    code-server \
      --bind-addr 127.0.0.1:${var.code_server_port} \
      --auth none \
      /workspace \
      > /tmp/code-server.log 2>&1 &
  EOT

  display_apps {
    vscode          = false
    vscode_insiders = false
    web_terminal    = true
    ssh_helper      = false
  }
}

resource "coder_app" "code_server" {
  agent_id     = coder_agent.main.id
  slug         = "code-server"
  display_name = "code-server"
  icon         = "/icon/code.svg"

  url = "http://localhost:${var.code_server_port}/?folder=/workspace"

  subdomain = false
  share     = "owner"

  healthcheck {
    url       = "http://localhost:${var.code_server_port}/healthz"
    interval  = 5
    threshold = 6
  }
}

resource "kubernetes_persistent_volume_claim_v1" "workspace" {
  metadata {
    name      = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
    namespace = var.namespace

    labels = {
      "app.kubernetes.io/name"     = "coder-workspace"
      "app.kubernetes.io/instance" = data.coder_workspace.me.name
    }
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.storage_class_name

    resources {
      requests = {
        storage = var.storage_size
      }
    }
  }
}

resource "kubernetes_pod_v1" "workspace" {
  count = data.coder_workspace.me.start_count

  metadata {
    name      = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
    namespace = var.namespace

    labels = {
      "app.kubernetes.io/name"      = "coder-workspace"
      "app.kubernetes.io/instance"  = data.coder_workspace.me.name
      "app.kubernetes.io/component" = "workspace"
    }
  }

  spec {
    container {
      name  = "workspace"
      image = var.workspace_image

      command = [
        "sh",
        "-c",
        coder_agent.main.init_script
      ]

      env {
        name  = "CODER_AGENT_TOKEN"
        value = coder_agent.main.token
      }

      resources {
        requests = {
          cpu    = var.cpu_request
          memory = var.memory_request
        }

        limits = {
          cpu    = var.cpu_limit
          memory = var.memory_limit
        }
      }

      volume_mount {
        name       = "workspace"
        mount_path = "/workspace"
      }
    }

    volume {
      name = "workspace"

      persistent_volume_claim {
        claim_name = kubernetes_persistent_volume_claim_v1.workspace.metadata[0].name
      }
    }
  }
}