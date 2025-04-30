terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git//?ref=v4.17.2"
}

include {
  path   = find_in_parent_folders()
  expose = true
}

dependency "vpc" {
  config_path = "../../vpc"
}

inputs = {
  name        = "terraform-allow-frp-sg"
  description = "allow frp proxy range"
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 7000
      to_port     = 7000
      protocol    = "tcp"
      description = "frp communication port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 7001
      to_port     = 7001
      protocol    = "tcp"
      description = "frp dashboard port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 6443
      to_port     = 6443
      protocol    = "tcp"
      description = "apiserver port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "https traffic port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "https traffic port"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
