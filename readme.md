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

### argo cd
1. create argocd namespace
    ```
    kubectl create namespace argocd
    ```
2. deploy argo cd with extension to namespace argocd
    ```
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.3.3/manifests/install.yaml
    ```

### note
- how to get initial argocd password
    ```
    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
    ```
- how to expose argo cd
    ```
    kubectl port-forward -n argocd svc/argocd-server 8080:443
    ```
- how to install argocd cli [link](https://argo-cd.readthedocs.io/en/stable/cli_installation/)
- how to change default password
    ```
    argocd account update-password
    ```

### deploy sample application
1. argocd login localhost:8080
2. argocd app create sample --repo https://github.com/warapong-pj/workshop.git --path sample --dest-server https://kubernetes.default.svc --dest-namespace default --revision dev --sync-policy automated --auto-prune
3. argocd app list
4. argocd app get sample
5. argocd app sync sample
6. argocd app delete sample

### argo rollouts
1. create argo-rollouts namespace
    ```
    kubectl create namespace argo-rollouts
    ```
2. deploy argo rollouts to cluster
    ```
    kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/download/v1.2.0/install.yaml
    ```

### note
- install argo rollouts plugin
    ```
    brew install argoproj/tap/kubectl-argo-rollouts
    ```

### deploy canary application
1. argocd login localhost:8080
2. argocd app create sample --repo https://github.com/warapong-pj/workshop.git --path canary --dest-server https://kubernetes.default.svc --dest-namespace default --revision dev --sync-policy automated --auto-prune
3. argocd app list
4. argocd app get sample
5. argocd app sync sample
6. kubectl argo rollouts list rollouts
7. kubectl argo rollouts get rollouts sample --watch
8. kubectl argo rollouts promote sample
9. argocd app delete sample

### deploy bluegreen application
1. argocd login localhost:8080
2. argocd app create sample --repo https://github.com/warapong-pj/workshop.git --path bluegreen --dest-server https://kubernetes.default.svc --dest-namespace default --revision dev --sync-policy automated --auto-prune
3. argocd app list
4. argocd app get sample
5. argocd app sync sample
6. kubectl argo rollouts list rollouts
7. kubectl argo rollouts get rollouts sample --watch
8. kubectl argo rollouts promote sample
9. argocd app delete sample
