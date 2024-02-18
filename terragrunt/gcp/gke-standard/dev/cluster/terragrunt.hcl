locals {
  environment = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.environment
  location    = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.location
  
  total_min_pool_size    = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.total_min_pool_size
  total_max_pool_size    = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.total_max_pool_size
  primary_pool_disk_size = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.primary_pool_disk_size
}

terraform {
  source = "tfr:///terraform-google-modules/kubernetes-engine/google//modules/private-cluster?version=30.0.0"
}

include "root" {
    path           = find_in_parent_folders()
    expose         = true
    merge_strategy = "deep"
}

include "network" {
    path           = "../dependencies/network.hcl"
    expose         = true
    merge_strategy = "deep"
}

include "node_pool_sa" {
    path           = "../dependencies/node_pool_sa.hcl"
    expose         = true
    merge_strategy = "deep"
}

inputs = {
    name               = "${local.environment}-gke-standard-cluster"
    regional           = true
    region             = local.location
    kubernetes_version = "latest"

    network                 = dependency.network.outputs.network_name
    subnetwork              = dependency.network.outputs.subnets_names[0]
    enable_private_endpoint = false
    enable_private_nodes    = true
    ip_range_pods           = "${local.environment}-gke-standard-pod-range"
    ip_range_services       = "${local.environment}-gke-standard-service-range"

    http_load_balancing         = true
    network_policy              = true
    filestore_csi_driver        = true
    horizontal_pod_autoscaling  = true
    deletion_protection         = false
    logging_service             = "logging.googleapis.com/kubernetes"
    monitoring_service          = "monitoring.googleapis.com/kubernetes"

    initial_node_count       = 0
    remove_default_node_pool = true
    create_service_account   = true

    cluster_autoscaling = {
      enabled             = false
      autoscaling_profile = "OPTIMIZE_UTILIZATION"
      max_cpu_cores       = 0
      min_cpu_cores       = 0
      max_memory_gb       = 0
      min_memory_gb       = 0
      gpu_resources       = []
      auto_repair         = true
      auto_upgrade        = true
    }

    node_pools = [
    {
      name            = "primary-node-pool"
      machine_type    = "e2-standard-2"
      total_min_count = local.total_min_pool_size
      total_max_count = local.total_max_pool_size
      disk_size_gb    = local.primary_pool_disk_size
      spot            = false
      autoscaling     = true
      auto_upgrade    = true
      auto_repair     = true
      service_account = dependency.node_pool_sa.outputs.email
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol",
    ]
  }
}

dependencies {
    paths = [
        "../network",
        "../node_pool_sa"
    ]
}