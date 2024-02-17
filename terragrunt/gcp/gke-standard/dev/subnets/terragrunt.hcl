locals {
  environment = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.environment
}

terraform {
  source = "tfr:///terraform-google-modules/network/google//modules/subnets?version=9.0.0"
}

include "root" {
    path           = find_in_parent_folders()
    expose         = true
    merge_strategy = "deep"
}

include "vpc" {
    path           = "../dependencies/vpc.hcl"
    expose         = true
    merge_strategy = "deep"
}

inputs = {
    network_name = dependency.vpc.outputs.network_name
}