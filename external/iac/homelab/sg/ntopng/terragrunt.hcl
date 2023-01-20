terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git//?ref=v4.17.1"
}

include {
  path   = find_in_parent_folders()
  expose = true
}

dependency "vpc" {
  config_path = "../../vpc"
}

inputs = {
  name        = "terraform-allow-ntopng-sg"
  description = "allow ntopng"
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      description = "ntopng dashboard"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
