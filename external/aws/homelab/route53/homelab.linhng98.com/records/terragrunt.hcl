terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-route53.git//modules/records?ref=v2.10.2"
}

include {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

dependency "zones" {
  config_path = "../zones"
}

inputs = {
  zone_name = sort(keys(dependency.zones.outputs.route53_zone_zone_id))[0]
  records = [
    {
      name = "*"
      type = "CNAME"
      ttl  = 3600
      records = [
        "linhng98.ddns.net",
      ]
    },
  ]
}
