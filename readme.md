### create cluster
1. create kubernetes by kind with config.yaml 
    ```
    kind create cluster --config cluster.yaml
    ```
2. get kube context from cluster
    ```
    kubectl cluster-info --context kind-kind
    ```

### destroy cluster
1. to cleanup cluster
    ```
    kind delete cluster
    ```


### install cilium 
1. add helm chart repository
    ```
    helm repo add cilium https://helm.cilium.io/
    ```
2. install cilium and hubble
    ```
    helm upgrade --install cilium cilium/cilium --version 1.11.3 \
        --namespace kube-system \
        --set hostServices.enabled=false \
        --set externalIPs.enabled=true \
        --set nodePort.enabled=true \
        --set hostPort.enabled=true \
        --set bpf.masquerade=false \
        --set image.pullPolicy=IfNotPresent \
        --set ipam.mode=kubernetes \
        --set hubble.enabled=true \
        --set hubble.relay.enabled=true \
        --set hubble.ui.enabled=true \
        --set kubeProxyReplacement=strict \
        --set k8sServiceHost=kind-control-plane \
        --set k8sServicePort=6443 \
        --set prometheus.enabled=true
    ```

### note
- namespace stuck as `Terminating`
    1. kubectl get namespace <NAMESPACE> -o json > <NAMESPACE>.json
    2. remove kubernetes from finalizers array which is under spec
    3. kubectl replace --raw "/api/v1/namespaces/<NAMESPACE>/finalize" -f ./<NAMESPACE>.json
    4. kubectl get namespace
