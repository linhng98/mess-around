terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-ec2-instance.git//?ref=v4.1.4"
}

include {
  path   = find_in_parent_folders()
  expose = true
}

dependency "vpc" {
  config_path = "../../vpc"
}

dependency "allow_ssh_sg" {
  config_path = "../../sg/ssh"
}

dependency "allow_frp_sg" {
  config_path = "../../sg/frp-server"
}

dependency "allow_internet_access_sg" {
  config_path = "../../sg/internet-access"
}

dependency "allow_ntopng_sg" {
  config_path = "../../sg/ntopng"
}

inputs = {
  ami           = "ami-02ee763250491e04a"
  instance_type = "t2.small"

  create_spot_instance = false

  monitoring                  = true
  associate_public_ip_address = true
  vpc_security_group_ids = [
    "${dependency.allow_ssh_sg.outputs.security_group_id}",
    "${dependency.allow_frp_sg.outputs.security_group_id}",
    "${dependency.allow_internet_access_sg.outputs.security_group_id}",
    "${dependency.allow_internet_access_sg.outputs.security_group_id}",
  ]
  subnet_id                   = dependency.vpc.outputs.public_subnets[0]
  key_name                    = "linhnv"
  user_data                   = <<-EOF
    #!/bin/bash
    frp_path=frp_0.44.0_linux_amd64
    curl -L "https://github.com/fatedier/frp/releases/download/v0.44.0/$frp_path.tar.gz" -O
    tar -zxvf $frp_path.tar.gz
    cat <<EOT > $frp_path/frps.ini
    [common]
    bind_port = 7000
    authentication_method = token
    vhost_http_port = 80
    vhost_https_port = 443
    token = ${get_env("FRP_TOKEN", "RandomStronkToken")}
    dashboard_port = 7001
    dashboard_user = admin
    dashboard_pwd = admin
    EOT
    ./$frp_path/frps -c $frp_path/frps.ini
  EOF
  user_data_replace_on_change = true
}
