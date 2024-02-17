locals {
  environment = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.environment
  location    = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.location
}

terraform {
  source = "tfr:///terraform-google-modules/cloud-nat/google?version=5.0.0"
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

include "nat_external_ip" {
    path           = "../dependencies/nat_external_ip.hcl"
    expose         = true
    merge_strategy = "deep"
}

inputs = {
    create_router = true
    region        = local.location
    router        = "${local.environment}-gke-standard-router"
    name          = "${local.environment}-gke-standard-nat"
    network       = dependency.vpc.outputs.network_name
    nat_ips       = dependency.nat_external_ip.outputs.self_links

    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

dependencies = {
    paths = [
        "../vpc",
        "../nat_external_ip"
    ]
}