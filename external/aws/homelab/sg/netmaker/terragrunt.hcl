terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git//?ref=v5.3.0"
}

include {
  path   = find_in_parent_folders()
  expose = true
}

dependency "vpc" {
  config_path = "../../vpc"
}

inputs = {
  name        = "netmaker-sg"
  description = "allow netmaker access"
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 51821
      to_port     = 51830
      protocol    = "udp"
      description = "wireguard port"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
