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
      role_name                        = "argocd"
      bound_service_account_names      = ["argo-cd-argocd-repo-server"]
      bound_service_account_namespaces = ["argo-cd"]
      token_policies                   = ["readonly"]
    }
  }
}


