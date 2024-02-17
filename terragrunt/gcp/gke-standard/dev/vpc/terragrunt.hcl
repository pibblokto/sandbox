locals {
  environment = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.environment
}

include "root" {
    path           = find_in_parent_folders()
    expose         = true
    merge_strategy = "deep"
}

terraform {
  source = "tfr:///terraform-google-modules/network/google//modules/vpc?version=9.0.0"
}

inputs = {
    network_name = "gke-standard-vpc-${local.environment}"
    description  = "vpn network for GKE Standard cluster"

    auto_create_subnetworks                = false
    delete_default_internet_gateway_routes = false
    
    enable_ipv6_ula     = false
    internal_ipv6_range = null
    mtu                 = 1460

    network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"

    routing_mode    = "GLOBAL"
    shared_vpc_host = false
}