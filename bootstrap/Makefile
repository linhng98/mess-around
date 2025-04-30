.POSIX:

export ROOK_OPERATOR_CHART="$(shell pwd)/../workload/rook-ceph-operator"
export ROOK_CLUSTER_CHART="$(shell pwd)/../workload/rook-ceph"
export VAULT_CHART="$(shell pwd)/../workload/vault"
export ARGO_CHART="$(shell pwd)/../workload/argo-cd"
export CERT_MANAGER_CHART="$(shell pwd)/../workload/cert-manager"

bootstrap:
	kubectl --kubeconfig ${KUBECONFIG} get nodes
	kubectl --kubeconfig ${KUBECONFIG} apply -f https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/charts/crds/crds/crd-servicemonitors.yaml
	kubectl --kubeconfig ${KUBECONFIG} apply -f https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/charts/crds/crds/crd-prometheusrules.yaml

	helm dependency update ${ARGO_CHART}
	helm dependency update ${VAULT_CHART}
	helm dependency update ${ROOK_OPERATOR_CHART}
	helm dependency update ${ROOK_CLUSTER_CHART}
	helm dependency update ${CERT_MANAGER_CHART}

	helm repo add jetstack https://charts.jetstack.io --force-update

	helm upgrade --install rook-ceph-operator --namespace rook-ceph-operator --create-namespace --kubeconfig ${KUBECONFIG} -f "${ROOK_OPERATOR_CHART}/values.yaml" ${ROOK_OPERATOR_CHART}
	helm upgrade --install rook-ceph --namespace rook-ceph --create-namespace --kubeconfig ${KUBECONFIG} -f "${ROOK_CLUSTER_CHART}/values.yaml" ${ROOK_CLUSTER_CHART}
	helm upgrade --install vault --namespace vault --create-namespace --kubeconfig ${KUBECONFIG} -f "${VAULT_CHART}/values.yaml" ${VAULT_CHART}
	helm upgrade --install argo-cd --namespace argo-cd --create-namespace --kubeconfig ${KUBECONFIG} -f "${ARGO_CHART}/values.yaml" ${ARGO_CHART}
	helm upgrade --install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.17.2 --set crds.enabled=true
	helm upgrade --install cert-manager --namespace cert-manager --create-namespace --kubeconfig ${KUBECONFIG} -f "${CERT_MANAGER_CHART}/values.yaml" ${CERT_MANAGER_CHART}
	kubectl --kubeconfig ${KUBECONFIG} apply -f application-set/
