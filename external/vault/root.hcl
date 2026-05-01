locals {
  # Extract the variables we need for easy access
  account_name = get_env("AWS_ACCOUNT_NAME")
  account_id   = get_env("AWS_ACCOUNT_ID")
  aws_region   = get_env("AWS_REGION")
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "vault" {}

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
    bucket         = "terragrunt-terraform-state-${local.account_name}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

terraform_version_constraint  = ">= 1.10.0"
terragrunt_version_constraint = ">= 0.77.0"
