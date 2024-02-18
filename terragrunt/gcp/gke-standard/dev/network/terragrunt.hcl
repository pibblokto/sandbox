locals {
  environment = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.environment
}

terraform {
  source = "tfr:///terraform-google-modules/network/google//modules/vpc?version=9.0.0"
}

include "root" {
    path           = find_in_parent_folders()
    expose         = true
    merge_strategy = "deep"
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

    subnets = [
        {
            subnet_name           = "${local.environment}-gke-standard-subnet"
            subnet_ip             = "10.1.0.0/16"
            subnet_region         = local.location
        }
    ]

    secondary_ranges = {
        "${local.environment}-gke-standard-subnet" = [
            {
                range_name    = "${local.environment}-gke-standard-pod-range"
                ip_cidr_range = "10.100.0.0/16"
            },
            {
                range_name    = "${local.environment}-gke-standard-service-range"
                ip_cidr_range = "10.120.0.0/16"
            }
        ]
    }
}