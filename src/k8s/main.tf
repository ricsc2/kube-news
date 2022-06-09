terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
	  version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "k8s" {
  
  name = var.nome_cluster
  region = var.region
  # Grab the latest version slug from `doctl kubernetes options version"
  version = "1.21.5-do.0"

  node_pool {
    name = "default"
	size = "s-2vcpu-4gb"
	node_count = 3
  }
}

resource "digitalocean_kubernetes_node_pool" "node_critical" {

  cluster_id = digitalocean_kubernetes_cluster.k8s.id-container
  
  name = "critical-pool"
  size = "s-2vcpu-4gb"
  node_count = 2
}

variable "do_token" {}
variable "nome_cluster" {}

output "kubernetes_endpoint" {
  value = "digitalocean_kubernetes_cluster.k8s.endpoint"
}

resource "local_file" "kube_config" {
  content = "digitalocean_kubernetes_cluster.k8s.kube_config.0.raw_config"
  filename = "kube_config.yaml"
}