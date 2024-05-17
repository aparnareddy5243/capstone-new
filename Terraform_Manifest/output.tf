output "cluster_name" {
  value = azurerm_kubernetes_cluster.appu-k8s-cluster.name
}

output "resource_group_id" {
  value = azurerm_resource_group.appu-rg.id
}
