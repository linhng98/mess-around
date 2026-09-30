# Tailscale access to the homelab

This chart installs the Tailscale operator and a subnet router advertising
`192.168.1.100/32`. The existing workload ApplicationSet discovers this
directory and deploys it into the `tailscale` namespace after it reaches master.
Helm rendering deliberately fails until the federated client ID and audience
are configured. No long-lived OAuth secret or ExternalSecret is needed.

The S3 OIDC issuer authenticates the operator's Kubernetes ServiceAccount.
Mac/Linux devices sign in using the normal Tailscale identity provider in the
same tailnet; the Kubernetes issuer is not an interactive user login provider.
Kubernetes TLS and client-certificate authentication remain end to end. The API
authentication proxy and its impersonation permissions are disabled. The route
covers only the API server IP; tailnet policy controls which ports are reachable.

## Configure the tailnet

In the Tailscale admin console, merge the following into your existing access
policy. Remove the old API proxy grant containing `tailscale.com/cap/kubernetes`.
The new grant permits your user to reach the API server on TCP port 6443.
Existing broader tailnet rules remain effective, including the default allow-all
grant; remove or narrow that grant if this port restriction should be enforced.

```json
{
  "tagOwners": {
    "tag:k8s-operator": [],
    "tag:k8s": ["tag:k8s-operator"]
  },
  "grants": [
    {
      "src": ["linhnguyen.workspace@gmail.com"],
      "dst": ["192.168.1.100/32"],
      "ip": ["tcp:6443"]
    }
  ]
}
```

Create an OpenID Connect federated identity under **Trust credentials**:

- Issuer: Custom issuer.
- Issuer URL: `https://mess-around-oidc-provider.s3.ap-southeast-1.amazonaws.com`
  (without `/.well-known/openid-configuration`).
- Subject: `system:serviceaccount:tailscale:operator`.
- Audience: leave blank when creating the identity so Tailscale generates it.
- Write scopes: `General/Services`, `Devices/Core`, and `Keys/Auth Keys`,
  restricted to `tag:k8s-operator`.

Put the resulting Client ID and Audience in `values.yaml` under
`tailscale-operator.oauth`. The generated audience is normally
`api.tailscale.com/<client-id>`; use the value returned by Tailscale.
The subnet router does not require Tailscale HTTPS certificates.

The public S3 discovery document points to the public S3 JWKS file. Both were
checked against the live cluster's issuer and public signing key during setup.
Keep the S3 JWKS updated when Kubernetes service-account signing keys rotate.
No additional unauthenticated discovery RBAC is needed for this S3 setup.

## Render and deploy

```sh
helm dependency build workload/tailscale
helm lint workload/tailscale
helm template tailscale workload/tailscale --namespace tailscale
```

Once configured and reviewed, commit/push through the existing GitOps process.
Check the Argo CD Application and operator after reconciliation:

```sh
kubectl -n argo-cd get application tailscale
kubectl -n tailscale get pods
kubectl -n tailscale logs deployment/operator --tail=100
kubectl get connector homelab-api
```

## Connect from Mac or Linux

After the router appears in Tailscale Machines, approve its advertised
`192.168.1.100/32` subnet route under Edit route settings. The router's machine
name starts with `homelab-api-router` and it uses `tag:k8s` by default.

Install Tailscale on each device and sign in to the same tailnet. macOS accepts
subnet routes by default. On Linux, enable them:

```sh
sudo tailscale set --accept-routes
```

Restore the original Kubernetes CA and admin client credentials in your
kubeconfig from a trusted backup or the RKE2 control plane. Do not use the
Tailscale proxy hostname or the dummy `unused` token. The cluster entry must use
`https://192.168.1.100:6443` and the original `certificate-authority-data`;
the user entry must contain your admin client certificate and private key.
Never disable TLS verification to work around a missing CA.

Once those credentials are restored, select the direct API endpoint and user:

```sh
kubectl --kubeconfig ~/.kube/homelab config set-cluster homelab --server=https://192.168.1.100:6443
kubectl --kubeconfig ~/.kube/homelab config set-context homelab --cluster=homelab --user=admin
kubectl --kubeconfig ~/.kube/homelab config use-context homelab
kubectl --kubeconfig ~/.kube/homelab get nodes
```

Your existing Kubernetes identity determines permissions. Admin credentials
retain their existing admin permissions; Tailscale only provides connectivity.
Argo CD pruning removes the old `tailscale-homelab-access` ClusterRoleBinding on
sync. The built-in Kubernetes `view` ClusterRole is not modified or deleted.
Test from outside the LAN to confirm the subnet route is carrying traffic.

## References

- [Operator OIDC federation](https://tailscale.com/docs/kubernetes-operator/manage-and-configure/workload-identity-federation)
- [Kubernetes subnet router setup](https://tailscale.com/docs/kubernetes-operator/connector/deploy-subnet-router)
