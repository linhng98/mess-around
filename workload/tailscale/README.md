# Tailscale access to the homelab

This chart installs the Tailscale operator and an authenticated Kubernetes API
proxy named `homelab-k8s`. The existing workload ApplicationSet discovers this
directory and deploys it into the `tailscale` namespace after it reaches master.
Helm rendering deliberately fails until the federated client ID and audience
are configured. No long-lived OAuth secret or ExternalSecret is needed.

The S3 OIDC issuer authenticates the operator's Kubernetes ServiceAccount.
Mac/Linux devices sign in using the normal Tailscale identity provider in the
same tailnet; the Kubernetes issuer is not an interactive user login provider.
This setup exposes the Kubernetes API only, not the LAN or all ClusterIP services.

## Configure the tailnet

In the Tailscale admin console, merge the following into your existing access
policy. Replace `YOUR_TAILSCALE_LOGIN` with your actual Tailscale login. The grant
maps that user to the Kubernetes group bound to the built-in `view` role by this
chart. Existing broader tailnet rules remain effective.

```json
{
  "tagOwners": {
    "tag:k8s-operator": [],
    "tag:k8s": ["tag:k8s-operator"]
  },
  "grants": [
    {
      "src": ["YOUR_TAILSCALE_LOGIN"],
      "dst": ["tag:k8s-operator"],
      "ip": ["tcp:443"],
      "app": {
        "tailscale.com/cap/kubernetes": [
          {"impersonate": {"groups": ["homelab-k8s-readers"]}}
        ]
      }
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
Enable MagicDNS and HTTPS certificates in the tailnet DNS settings.

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
```

## Connect from Mac or Linux

Install Tailscale on each device and sign in to the same tailnet. On Linux,
start the client with `sudo tailscale up`; on macOS, sign in through the app
and ensure its CLI is available. Use the actual operator FQDN from the Tailscale
Machines page in place of `<tailnet>` below:

```sh
tailscale configure kubeconfig https://homelab-k8s.<tailnet>.ts.net
kubectl get namespaces
kubectl get pods -A
kubectl auth can-i create deployments -A
```

The last command should report `no` with the default read-only role. For
administrative access, explicitly change `access.clusterRole` to `cluster-admin`
and review the corresponding tailnet grant. The proxy uses the device owner's
Tailscale identity, so these instructions assume untagged personal devices.

## References

- [Operator OIDC federation](https://tailscale.com/docs/kubernetes-operator/manage-and-configure/workload-identity-federation)
- [API proxy setup](https://tailscale.com/docs/kubernetes-operator/api-server-access/setup-api-over-tailscale)
- [API proxy RBAC](https://tailscale.com/docs/kubernetes-operator/api-server-access/auth-and-rbac)
