locals {
  environment = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.environment
  location    = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.location
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
    region = local.location

    address_type = "EXTERNAL"
    names        = [
        "${local.environment}-gke-standard-nat-address"
    ]
}