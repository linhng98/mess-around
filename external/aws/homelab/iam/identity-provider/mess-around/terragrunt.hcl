terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-github-oidc-provider?ref=v5.58.0"
}

include {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

inputs = {
  client_id_list = [
    "sts.amazonaws.com",
  ]
  url                    = "https://mess-around-oidc-provider.s3.ap-southeast-1.amazonaws.com"
  additional_thumbprints = []
}
