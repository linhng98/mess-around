terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-route53.git//modules/zones?ref=v5.0.0"
}

include {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

inputs = {
  zones = {
    "homelab.linhng98.com" = {
      comment = "homelab zone"
    }
  }
}
