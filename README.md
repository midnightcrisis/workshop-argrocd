### Workshop Repository

### create cluster
1. create kubernetes by kind with config.yaml 
    ```
    kind create cluster --config cluster.yaml
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
        --set kubeProxyReplacement=strict \
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
        --set k8sServiceHost=kind-control-plane \
        --set k8sServicePort=6443
    ```
### note
- to expose hubble ui
    ```
    kubectl port-forward -n kube-system svc/hubble-ui 8080:80
    ```

### deploy sample application
1. create namespace cilium-test to deploy example application
    ```
    kubectl create ns cilium-test
    ```
2. deploy example application
    ```
    kubectl apply -n cilium-test -f https://raw.githubusercontent.com/cilium/cilium/v1.9/examples/kubernetes/connectivity-check/connectivity-check.yaml
    ```
### note
kubectl get pods -n cilium-test

### destroy cluster
1. to cleanup cluster
    ```
    kind delete cluster
    ```