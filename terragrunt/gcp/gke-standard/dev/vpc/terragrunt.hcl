locals {
  environment = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.environment
}

include "root" {
    path           = find_in_parent_folders()
    expose         = true
    merge_strategy = "deep"
}