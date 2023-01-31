.POSIX:

export KUBECONFIG="$(shell pwd)/../metal/roles/rke2/files/kubeconfig.yaml"
export ROOK_CHART="$(shell pwd)/../workload/rook-ceph"
export VAULT_CHART="$(shell pwd)/../workload/vault"
export ARGO_CHART="$(shell pwd)/../workload/argo-cd"

bootstrap:
	kubectl --kubeconfig ${KUBECONFIG} get nodes
	kubectl --kubeconfig ${KUBECONFIG} apply -f https://github.com/rancher/system-upgrade-controller/releases/download/v0.10.0/system-upgrade-controller.yaml
	kubectl --kubeconfig ${KUBECONFIG} apply -f https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/crds/crd-servicemonitors.yaml
	kubectl --kubeconfig ${KUBECONFIG} apply -f https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/crds/crd-prometheusrules.yaml
	kubectl --kubeconfig ${KUBECONFIG} apply -f https://raw.githubusercontent.com/rook/rook/master/deploy/examples/crds.yaml
	helm dependency update ${ARGO_CHART}
	helm dependency update ${VAULT_CHART}
	helm dependency update ${ROOK_CHART}
	helm upgrade --install rook-ceph --namespace rook-ceph --create-namespace --kubeconfig ${KUBECONFIG} -f "${ROOK_CHART}/values.yaml" ${ROOK_CHART}
	helm upgrade --install vault --namespace vault --create-namespace --kubeconfig ${KUBECONFIG} -f "${VAULT_CHART}/values.yaml" ${VAULT_CHART}
	helm upgrade --install argo-cd --namespace argo-cd --create-namespace --kubeconfig ${KUBECONFIG} -f "${ARGO_CHART}/values.yaml" ${ARGO_CHART}
	kubectl --kubeconfig ${KUBECONFIG} apply -f application-set/
