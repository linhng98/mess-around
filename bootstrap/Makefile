.POSIX:

KUBECONFIG="$(shell pwd)/../metal/roles/rke2/files/kubeconfig.yaml"
ARGO_CHART="$(shell pwd)/../workload/argo-cd"

bootstrap:
	kubectl --kubeconfig ${KUBECONFIG} get nodes
	kubectl create ns system-upgrade
	kubectl --kubeconfig ${KUBECONFIG} apply -f https://github.com/rancher/system-upgrade-controller/releases/download/v0.10.0/system-upgrade-controller.yaml
	kubectl --kubeconfig ${KUBECONFIG} apply -f https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/crds/crd-servicemonitors.yaml
	helm dependency update ${ARGO_CHART}
	helm upgrade --install argo-cd --namespace argo-cd --create-namespace --kubeconfig ${KUBECONFIG} -f "${ARGO_CHART}/values.yaml" ${ARGO_CHART}
	kubectl --kubeconfig ${KUBECONFIG} apply -f application-set/
