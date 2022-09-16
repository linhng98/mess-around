# Mess Around

## Foreword
- Got idea and well-structed ansible code from [khuedoan's homelab](https://github.com/khuedoan/homelab.git), he is a talented and enthusiastic SRE, totally worth taking a look at his awesome project

## Technology stack
| Icon                                                                                                                                                                    | Name       | Description                                                                                                                                 |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Logo-ubuntu_cof-orange-hex.svg/1200px-Logo-ubuntu_cof-orange-hex.svg.png" width="25" height="25" /> | Ubuntu     | Ubuntu is a Linux distribution based on Debian                                                                                              |
| <img src="https://www.docker.com/wp-content/uploads/2022/03/vertical-logo-monochromatic.png" width="25" height="25" />                                                  | Docker     | Containerize PXE server boot                                                                                                                |
| <img src="https://www.suse.com/c/wp-content/uploads/2022/06/RKE.jpeg" width="25" height="25" />                                                                         | Rke2       | Kubernetes distribution that focuses on security and compliance for U.S                                                                     |
| <img src="https://kube-vip.io/images/kube-vip.png" width="25" height="25" />                                                                                            | Kube-vips  | Kubernetes clusters with a virtual IP and load balancer for both the control plane and LoadBalancer                                         |
| <img src="https://global.discourse-cdn.com/standard11/uploads/gruntwork/original/1X/451c24614aece67849fd62d0432d77ecd00735c6.png" width="25" height="25" />             | Terragrunt | Terragrunt is a thin wrapper that provides extra tools for keeping your configurations DRY                                                  |
| <img src="https://avatars.githubusercontent.com/u/52939924?v=4" width="25" height="25" />                                                                               | Terraform  | Terraform is an open-source, infrastructure as code, software tool created by HashiCorp                                                     |
| <img src="https://cncf-branding.netlify.app/img/projects/argo/icon/color/argo-icon-color.png" width="25" height="25" />                                                 | ArgoCD     | ArgoCD continuously monitoring all running applications and comparing their live state to the desired state specified in the Git repository |

## Reference
- https://www.youtube.com/watch?v=E_OlsA1hF4k
- https://askubuntu.com/questions/1235723/automated-20-04-server-installation-using-pxe-and-live-server-image
- https://ubuntu.com/server/docs/install/netboot-amd64
- https://github.com/lablabs/ansible-role-rke2
