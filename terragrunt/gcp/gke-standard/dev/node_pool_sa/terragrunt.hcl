locals {
  environment = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.environment
}

terraform {
  source = "tfr:///terraform-google-modules/address/google?version=3.2.0"
}

include "root" {
    path           = find_in_parent_folders()
    expose         = true
    merge_strategy = "deep"
}

inputs = {
    display_name = "${local.environment}-primary-node-pool-sa"
    names        = ["${local.environment}-primary-node-pool-sa"]
}
