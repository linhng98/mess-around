terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-assumable-role-with-oidc?ref=v5.59.0"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

dependency "idp" {
  config_path = "../../identity-provider/mess-around/"
}

locals {
  account_id = include.root.inputs.account_id
}

inputs = {
  create_role  = true
  role_name    = "${basename(get_terragrunt_dir())}"
  provider_url = dependency.idp.outputs.url
  role_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]
  oidc_fully_qualified_subjects = ["system:serviceaccount:atlantis:atlantis"]
}
