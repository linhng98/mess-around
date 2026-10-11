# Media services

The official Jellyfin subchart is unchanged. Companion services are rendered by
`templates/media-stack.yaml` in the same namespace to share `jellyfin-media`.
Commit and sync the existing Jellyfin Argo CD Application to deploy them.

| Service | LAN address | Internal address |
| --- | --- | --- |
| Jellyfin | http://192.168.1.101:30096 | http://jellyfin:8096 |
| Seerr | http://192.168.1.101:30055 | http://seerr:5055 |
| Radarr | http://192.168.1.101:30787 | http://radarr:7878 |
| Prowlarr | http://192.168.1.101:30696 | http://prowlarr:9696 |
| qBittorrent | http://192.168.1.101:30080 | http://qbittorrent:30080 |

NodePorts are reachable on cluster nodes, not exclusively from the LAN by
themselves. Do not forward them on the router or publish them through a tunnel.
Tailscale clients may also reach them according to your routes and grants.
Enable authentication on every application even on the LAN.

## First-run setup

1. Open qBittorrent. The initial username is `admin`; find the temporary password
   with `kubectl -n jellyfin logs deployment/qbittorrent`. Set a permanent password
   immediately under Settings > Web UI, retaining authentication and CSRF checks.
   Under Downloads, set the default save path to `/media/downloads` and create a
   `radarr` category with save path `/media/downloads/radarr`. Disable UPnP/NAT-PMP
   port forwarding if enabled. This deployment uses normal internet egress, not a
   VPN, and does not expose a peer NodePort. Outbound peer connections still work,
   but incoming peer connectivity is limited.
2. Open Radarr, create login credentials, and set root folder `/media/movies`.
   Add a qBittorrent download client: host `qbittorrent`, port `30080`, category
   `radarr`, and the credentials from step 1. Test and save. Keep Completed Download
   Handling enabled and enable hardlinks under advanced Media Management settings.
   Select a quality profile and size limits appropriate for the shared 100Gi volume.
3. Open Prowlarr, create login credentials, and add your authorized indexers.
   Under Settings > Apps, add Radarr with Prowlarr URL `http://prowlarr:9696`,
   Radarr URL `http://radarr:7878`, and Radarr's API key from Settings > General.
   Test and sync the indexers. Prowlarr does not need its own download client for
   this workflow: Radarr sends downloads to qBittorrent.
4. In Jellyfin, add a Movies library at `/media/movies`. Configure periodic library
   scans; do not rely only on filesystem notifications over CephFS. In Radarr,
   optionally add a Jellyfin connection under Settings > Connect to notify
   `jellyfin:8096` on import/upgrade using a Jellyfin API key.
5. Open Seerr, select Jellyfin, connect to `http://jellyfin:8096`, sign in with your
   Jellyfin administrator account, and sync/select the Movies library. Set the
   external Jellyfin URL to `http://192.168.1.101:30096`. Add Radarr using
   `http://radarr:7878`, its API key, `/media/movies`, and your chosen quality
   profile. Make it the default server and enable automatic search. Set request
   approval permissions deliberately; enable movie auto-approval for your own
   user if you want requests to download without an additional approval step.
6. Request an authorized movie in Seerr. Check Radarr Activity and qBittorrent for
   progress. After import and a Jellyfin scan, play it using a Jellyfin client
   connected to `http://192.168.1.101:30096`.

API keys and credentials belong in the applications' persistent settings, not in
Git. No indexer accounts or download sources are preconfigured. TV automation
requires Sonarr, which is not included here.

## Storage and upgrades

Radarr and qBittorrent mount the entire CephFS PVC at `/media` read/write, using
UID/GID 1000. Jellyfin keeps its read-only media mount. Avoid separate mounts for
downloads and movies: a shared filesystem allows hardlinks without a second copy
while seeding. Do not manually delete files that qBittorrent is still seeding.

Each application has a separate RBD settings PVC and a single Recreate deployment
to avoid concurrent SQLite writers. LinuxServer containers initialize as root and
drop to UID/GID 1000 for the application; Seerr runs as UID/GID 1000 directly.
Settings PVCs are protected from Argo CD pruning/deletion, but not manual PVC or
namespace deletion. Back them up before upgrades. The media capacity remains
100Gi; downloads and the library share that space.

## Validation

```sh
helm dependency build workload/jellyfin
helm lint workload/jellyfin
helm template jellyfin workload/jellyfin --namespace jellyfin
```

References: [Seerr](https://docs.seerr.dev/),
[Radarr](https://wiki.servarr.com/radarr/settings),
[Prowlarr](https://wiki.servarr.com/prowlarr/quick-start-guide),
[qBittorrent container](https://docs.linuxserver.io/images/docker-qbittorrent/).
