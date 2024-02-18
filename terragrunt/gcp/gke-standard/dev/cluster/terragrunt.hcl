locals {
  environment = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.environment
  location    = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.location
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
    ip_range_pods           = "${local.environment}-gke-standard-pod-range"
    ip_range_services       = "${local.environment}-gke-standard-service-range"

    http_load_balancing         = true
    network_policy              = true
    filestore_csi_driver        = true
    horizontal_pod_autoscaling  = true
    logging_service             = "logging.googleapis.com/kubernetes"
    deletion_protection         = false

    initial_node_count       = 0
    remove_default_node_pool = true
    create_service_account   = true

    node_pools = [
    {
      name            = "primary-node-pool"
      machine_type    = "e2-standard-2"
      total_min_count = 1
      total_max_count = 3
      disk_size_gb    = 75
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