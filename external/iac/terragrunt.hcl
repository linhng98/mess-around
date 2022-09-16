locals {
  # Extract the variables we need for easy access
  account_name = "linhng98"
  account_id   = "370400765644"
  aws_region   = "ap-southeast-1"
  tags = {
    Terraform   = "true"
    Environment = "homelab"
    Owner       = "linhng98"
  }
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  allowed_account_ids = ["${local.account_id}"]
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terragrunt-terraform-state-${local.account_name}-${local.aws_region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

terraform_version_constraint  = ">= 1.0.0"
terragrunt_version_constraint = ">= 0.31.0"

inputs = {
  account_name = local.account_name
  account_id   = local.account_id
  aws_region   = local.aws_region
  tags         = local.tags
}
