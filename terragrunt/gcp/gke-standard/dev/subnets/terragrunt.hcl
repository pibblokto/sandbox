locals {
  environment = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.environment
  location    = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.location
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

    subnets = [
        {
            subnet_name           = "${local.environment}-subnet-01"
            subnet_ip             = "10.1.0.0/24"
            subnet_region         = local.location
        },
        {
            subnet_name           = "${local.environment}-subnet-02"
            subnet_ip             = "10.1.1.0/24"
            subnet_region         = local.location
        },
        {
            subnet_name           = "${local.environment}-subnet-03"
            subnet_ip             = "10.1.2.0/24"
            subnet_region         = local.location
        }
    ]

    secondary_ranges = {
        "${local.environment}-subnet-01" = [
            {
                range_name    = "${local.environment}-subnet-01-secondary-01"
                ip_cidr_range = "10.2.0.0/16"
            },
        ]
        
        "${local.environment}-subnet-02" = [
            {
                range_name    = "${local.environment}-subnet-02-secondary-01"
                ip_cidr_range = "10.3.0.0/16"
            },
        ]

        "${local.environment}-subnet-03" = [
            {
                range_name    = "${local.environment}-subnet-03-secondary-01"
                ip_cidr_range = "10.3.0.0/16"
            },
        ]
    }
}

dependencies = {
    paths = [
        "../vpc"
    ]
}