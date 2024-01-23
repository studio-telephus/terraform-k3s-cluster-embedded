locals {
  worker_labels = merge(var.worker_labels, {
    "node.kubernetes.io/pool" = "worker-pool"
  })
  server_labels = length(var.containers_worker) > 0 ? merge(var.server_labels, {
    "node.kubernetes.io/type" = "master"
    }) : merge(var.server_labels, {
    "node.kubernetes.io/type" = "master"
  }, local.worker_labels)
}

module "k3s" {
  source               = "xunleii/k3s/module"
  k3s_version          = var.k3s_version
  cluster_domain       = var.cluster_domain
  k3s_install_env_vars = var.k3s_install_env_vars
  global_flags         = var.global_flags
  drain_timeout        = var.drain_timeout
  managed_fields       = var.managed_fields
  use_sudo             = var.use_sudo
  cidr = {
    pods     = var.cidr_pods
    services = var.cidr_services
  }
  servers = {
    for i, item in var.containers_server : item.name => {
      ip = item.ipv4_address
      connection = {
        user        = var.ssh_username
        host        = item.ipv4_address
        private_key = trimspace(base64decode(var.ssh_private_key))
        timeout     = var.node_connection_timeout
      }
      flags  = var.server_flags
      labels = local.server_labels
      annotations = {
        "server.index" : i
      }
    }
  }
  agents = {
    for i, item in var.containers_worker : item.name => {
      ip = item.ipv4_address
      connection = {
        user        = var.ssh_username
        host        = item.ipv4_address
        private_key = trimspace(base64decode(var.ssh_private_key))
        timeout     = var.node_connection_timeout
      }
      labels = local.worker_labels
      annotations = {
        "worker.index" : i
      }
    }
  }
}
