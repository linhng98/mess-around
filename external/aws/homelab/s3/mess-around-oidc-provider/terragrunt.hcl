terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket.git//?ref=v4.11.0"
}

include {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

inputs = {
  bucket                  = "${basename(get_terragrunt_dir())}"
  attach_policy           = true
  block_public_acls       = false
  ignore_public_acls      = true
  block_public_policy     = false
  restrict_public_buckets = false
  policy                  = <<EOF
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
