terraform {
  source = "git@github.com:linhng98/terraform-hashicorp-vault-modules.git//policy?ref=master"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  policies = {
    readonly = {
      policy = <<EOF
        path "secret/data/*" {
          capabilities = ["read", "list"]
        }
      EOF
    }
  }
}

