terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket.git//?ref=v4.1.2"
}

include {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  bucket = "mess-around-kaniko"
  acl    = "private"

  versioning = {
    enabled = false
  }
  force_destroy = true
}
