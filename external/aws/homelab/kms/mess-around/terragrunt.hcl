terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-kms.git//?ref=v3.1.0"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

dependency "kms_role" {
  config_path = "../../iam/role/mess-around_AWS_KMS_Encrypt_Role/"
}

locals {
  account_id = include.root.inputs.account_id
}

inputs = {
  description = "HCP vault auto unseal"
  key_usage   = "ENCRYPT_DECRYPT"
  aliases     = ["mess-around/vault"]

  key_administrators = ["arn:aws:iam::${local.account_id}:user/terraform"]
  key_owners         = ["arn:aws:iam::${local.account_id}:user/terraform"]
  key_users          = [dependency.kms_role.outputs.iam_role_arn]
  key_service_users  = [dependency.kms_role.outputs.iam_role_arn]
}

