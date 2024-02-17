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


inputs = {
    subnetwork    = ""
    ip_range_pods = ""
    network       = dependency.network.outputs.network_name


    initial_node_count       = 0
    remove_default_node_pool = true
}

dependencies = {
    paths = [
        "../vpc",
        "../subnets"
    ]
}