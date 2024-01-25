output "k3s_kube_config" {
  description = "Genereated kubeconfig."
  value       = module.k3s_cluster.kube_config
  sensitive   = true
}

output "k3s_kubernetes" {
  description = "Authentication credentials of Kubernetes (full administrator)."
  value       = module.k3s_cluster.kubernetes
  sensitive   = true
}

output "k3s_kubernetes_cluster_secret" {
  description = "Secret token used to join nodes to the cluster."
  value       = module.k3s_cluster.kubernetes_cluster_secret
  sensitive   = true
}

output "k3s_kubernetes_ready" {
  description = "Dependency endpoint to synchronize k3s installation and provisioning."
  value       = module.k3s_cluster.kubernetes_ready
}

output "k3s_summary" {
  description = "Current state of k3s (version & nodes)."
  value       = module.k3s_cluster.summary
}
