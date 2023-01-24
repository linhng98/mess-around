terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git//?ref=v3.19.0"
}

include {
  path   = find_in_parent_folders()
  expose = true
}


inputs = {
  name = "homelab-vpc"
  cidr = "10.0.0.0/16"

  azs              = ["${include.inputs.aws_region}a", "${include.inputs.aws_region}b", "${include.inputs.aws_region}c"]
  private_subnets  = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  public_subnets   = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
  database_subnets = ["10.0.240.0/24", "10.0.241.0/24", "10.0.242.0/24"]

  enable_nat_gateway           = false
  create_database_subnet_group = true
  single_nat_gateway           = false
  enable_vpn_gateway           = false
}
