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
    
### fluxcd
### example
flux bootstrap git \
  --url=ssh://git@github.com/warapong-pj/workshop.git \
  --branch=dev \
  --path=clusters/dev \
  --private-key-file=.ssh/id_rsa

flux create source helm sealed-secrets \
  --interval=1h \
  --url=https://bitnami-labs.github.io/sealed-secrets \
  --export > sealed-secret-source.yaml

flux create helmrelease sealed-secrets \
  --interval=1h \
  --release-name=sealed-secrets-controller \
  --target-namespace=flux-system \
  --source=HelmRepository/sealed-secrets \
  --chart=sealed-secrets \
  --chart-version="=2.1.7" \
  --crds=CreateReplace \
  --export > sealed-secret-helm.yaml
