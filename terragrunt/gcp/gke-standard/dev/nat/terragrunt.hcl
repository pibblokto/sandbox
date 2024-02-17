locals {
  environment = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.environment
  location    = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.location
}

terraform {
  source = "tfr:///terraform-google-modules/cloud-router/google?version=6.0.2"
}

include "root" {
    path           = find_in_parent_folders()
    expose         = true
    merge_strategy = "deep"
}

include "router" {
    path           = "../dependencies/router.hcl"
    expose         = true
    merge_strategy = "deep"
}

include "vpc" {
    path           = "../dependencies/vpc.hcl"
    expose         = true
    merge_strategy = "deep"
}

inputs = {
    name    =  "${local.environment}-gke-standard-cloud-router"
    network = dependency.vpc.outputs.network_name
    project = local.project
    region  = location
}