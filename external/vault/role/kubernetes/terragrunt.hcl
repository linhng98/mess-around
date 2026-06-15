terraform {
  source = "git@github.com:linhng98/terraform-hashicorp-vault-modules.git//kubernetes-auth?ref=master"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  kubernetes_host = "https://kubernetes.default.svc"
  path            = "kubernetes"
  backend_roles = {
    argocd = {
      role_name                        = "external-secrets"
      bound_service_account_names      = ["external-secrets"]
      bound_service_account_namespaces = ["external-secrets"]
      token_policies                   = ["readonly"]
    }
  }
}
