locals {
    project_id                = "piblokto"
    location                  = "europe-west3"
    environment               = "dev"
    primary_pool_machine_type = "e2-standard-2"
    total_min_pool_size       = 1
    total_max_pool_size       = 3
    primary_pool_disk_size    = 75
}