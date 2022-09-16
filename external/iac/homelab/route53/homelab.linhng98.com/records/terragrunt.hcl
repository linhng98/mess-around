terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-route53.git//modules/records?ref=v2.9.0"
}

include {
  path   = find_in_parent_folders()
  expose = true
}

dependency "ec2" {
  config_path = "../../../ec2/frp-server"
}

dependency "zones" {
  config_path = "../zones"
}

inputs = {
  zone_name = sort(keys(dependency.zones.outputs.route53_zone_zone_id))[0]
  records = [
    {
      name = "*"
      type = "A"
      ttl  = 3600
      records = [
        dependency.ec2.outputs.eip_ip,
      ]
    },
  ]
}
