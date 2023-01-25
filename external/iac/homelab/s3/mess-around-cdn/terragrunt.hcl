terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket.git//?ref=v3.6.1"
}

include {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  bucket        = "${basename(get_terragrunt_dir())}"
  acl           = "public-read"
  attach_policy = true
  policy        = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${basename(get_terragrunt_dir())}/*"
            ]
        }
    ]
  }
  EOF

  versioning = {
    enabled = true
  }
  force_destroy = true
}
