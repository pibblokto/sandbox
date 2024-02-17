skip = true

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

remote_state {
  backend = "gcs"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = "piblokto-state-bucket"
    prefix     = "${basename(dirname(find_in_parent_folders()))}/${path_relative_to_include()}/terraform.tfstate"
  }
}

generate "provider" {

  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  
  contents  = <<EOF
  provider "google" {
  project   = "${local.common_vars.locals.project_id}"
}
EOF
}

inputs = {
    project_id = local.common_vars.locals.project_id
}