
### argo cd
1. create argocd namespace
    ```
    kubectl create namespace argocd
    ```
2. deploy argo cd to cluster
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
