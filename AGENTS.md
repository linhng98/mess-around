<claude-mem-context>
# Memory Context

# [mess-around] recent context, 2026-06-15 10:33pm GMT+7

Legend: 🎯session 🔴bugfix 🟣feature 🔄refactor ✅change 🔵discovery ⚖️decision 🚨security_alert 🔐security_note
Format: ID TIME TYPE TITLE
Fetch details: get_observations([IDs]) | Search: mem-search skill

Stats: 36 obs (15,528t read) | 291,492t work | 95% savings

### May 1, 2026
1 4:07p 🔵 Rook-Ceph Operator v1.19.5 Values Snapshot for Breaking Change Audit
2 " 🔵 Rook v1.19.5 Is Latest Release — No Upgrade Needed
3 " 🔵 Rook Master values.yaml Shrunk 65% vs v1.19.5 — Major Chart Restructure Ahead
4 " 🔵 Massive Breaking Change: All CSI Config Removed from Rook Operator Helm Values in Master
5 4:10p 🔵 Rook-Ceph Helm Values Files Located in linhng98/mess-around Repo
6 " 🔵 Chart.yaml Pins Rook-Ceph at v1.17.7 — Two Major Versions Behind Latest
7 4:11p 🔵 v1.17.7 → v1.19.5 Diff: Minor Chart Changes, PSP Removed, CSI Operator Sub-Chart Added
S4 Rook-Ceph full audit: operator chart v1.17.7 vs v1.19.5 vs upcoming v1.20, plus cluster chart v1.19.5 override validation and design risk review (May 1 at 4:11 PM)
8 4:13p 🔵 Rook-Ceph Cluster Chart Directory Located
9 " 🔵 Version Mismatch: Operator v1.17.7 vs Cluster Chart v1.19.5 — Unsupported Configuration
10 4:14p 🔵 Rook-Ceph Cluster Values Diverge from Upstream Defaults — Data Safety and Resource Risks
S112 ArgoCD cross-application variable sharing — patterns and recommendations (May 1 at 4:14 PM)
### Jun 11, 2026
200 9:01p 🔵 ArgoCD Cross-Application Variable Sharing Patterns
S113 Rook-ceph Helm upgrade failing with SSA field manager conflicts — root cause diagnosed, fix identified (Jun 11 at 9:01 PM)
201 9:35p 🔵 Rook-Ceph Helm Upgrade Fails with Server-Side Apply Field Manager Conflicts
202 9:36p 🔵 Helm v4.1.1 in Use, No --force-conflicts Flag in Bootstrap Makefile
203 " 🔵 Rook-Ceph values.yaml SSA Conflict Fields Identified
S114 Rook-ceph Helm upgrade SSA conflict — root cause confirmed, memory updated, Makefile fix pending (Jun 11 at 9:37 PM)
204 9:39p 🔵 Rook-Ceph Operator and Cluster Charts Both at v1.19.5 — No Version Mismatch
205 " ✅ Persisted Rook-Ceph Version Correction and SSA Fix to Project Memory
S115 Rook-ceph values.yaml config audit vs upstream defaults — misconfigs ranked and fix path identified (Jun 11 at 9:39 PM)
206 9:54p 🔵 Rook-Ceph values.yaml Misconfigurations vs Upstream Defaults
S116 Project memory housekeeping — added always-reread-files rule and updated MEMORY.md index (Jun 11 at 9:54 PM)
207 9:55p ✅ Project Memory Rule: Always Re-Read Files Fresh Before Analysis
S118 Continued rook-ceph values.yaml config cleanup iteration + bootstrap/Makefile inspection (Jun 11 at 9:55 PM)
208 9:56p ✅ Rook-Ceph values.yaml: CephCluster Resource Limits Removed, MDS CPU Limit Remains
S119 bootstrap/Makefile --force-conflicts confirmed and applied; rook-ceph upgrade unblocked (Jun 11 at 9:56 PM)
S117 Rook-ceph values.yaml iterative config cleanup — CephCluster cpu limits removed, MDS cpu limit and dataPools conflict remain (Jun 11 at 9:56 PM)
209 " 🔴 bootstrap/Makefile: Added --force-conflicts to Rook-Ceph Helm Upgrade
### Jun 15, 2026
252 10:15p 🔵 mimir-distributed 6.0.6 Breaking Changes Analysis
253 " 🔵 Existing Mimir Deployment State: v5.7.0, No Kafka, Zone Replication Disabled
254 10:16p 🔵 mimir-distributed 5.7.0→6.0.6: nginx renamed to gateway, app bumped 2.16.0→3.0.4, enterprise removed
255 10:17p 🔵 Live Mimir Cluster Already Degraded: Ingesters, Compactor, Store-Gateway, Ruler All CrashLoopBackOff
256 " 🔵 mimir-distributed kubeVersion Constraint Bumped: 1.20→1.29 Required for 6.0.6
257 " 🔵 Automated Key Diff: Only `nginx` is Incompatible Top-Level Key Between Current Values and 6.0.6
258 10:18p 🔵 helm template Succeeded: 6.0.6 Renders With Current Values, But Kafka StatefulSet and Service Rename Are Active
259 10:19p 🔵 mimir-nginx Service Name Referenced in observability and tempo workloads — Must Preserve Name on Upgrade
261 10:25p 🔵 AWS Credential Secrets in rook-s3 Namespace — ClusterSecretStore Needed
262 10:26p 🔵 Rook-Ceph OBC Auto-Creates Secrets — ExternalSecrets Operator Already Deployed
263 " 🔵 ExternalSecrets CRDs Installed, Secrets Confirmed Live, Cluster DNS Intermittent
264 " 🔵 ClusterSecretStore Kubernetes Provider Schema — API Version v1, ServiceAccount Auth Required
265 " 🔵 External-Secrets ServiceAccounts Confirmed; charts/ Directory Missing (Same Pattern as Mimir)
266 10:27p 🟣 ClusterSecretStore rook-s3 Created with Scoped RBAC
267 " ✅ rook-s3-clustersecretstore.yaml YAML Syntax Validated
S125 Generate ClusterSecretStore for rook-ceph S3 bucket credentials in rook-s3 namespace (Jun 15 at 10:27 PM)
268 " 🔵 Server-Side Dry-Run Aborted — ClusterSecretStore Not Live-Validated

Access 291k tokens of past work via get_observations([IDs]) or mem-search skill.
</claude-mem-context>
