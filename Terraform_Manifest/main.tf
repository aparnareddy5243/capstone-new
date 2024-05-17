# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.99.0"
    }
  }
  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "appu-rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "appu-acr" {
  name                = var.container_registry_name
  sku                 = "Standard"
  resource_group_name = azurerm_resource_group.appu-rg.name
  location            = azurerm_resource_group.appu-rg.location
}

resource "azurerm_kubernetes_cluster" "appu-k8s-cluster" {
  name                = var.cluster_name
  location            = azurerm_resource_group.appu-rg.location
  resource_group_name = azurerm_resource_group.appu-rg.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }

  network_profile {
    load_balancer_sku = "Standard"
    network_plugin    = "kubenet"
  }
}

resource "azurerm_role_assignment" "enablePulling" {
  principal_id                     = azurerm_kubernetes_cluster.appu-k8s-cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.appu-acr.id
  skip_service_principal_aad_check = true
}
