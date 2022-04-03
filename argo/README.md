### argo cd
1. create argocd namespace
    ```
    kubectl create namespace argocd
    ```
2. deploy argo cd with extension to namespace argocd
    ```
    kubectl apply -k argo/ -n argocd
    ```

3. deploy argo rollout to namespace argocd
    ```
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/rollout-extension/v0.1.0/manifests/install.yaml
    ```

### note
- to get initial argocd password
    ```
    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
    ```
- to expose argo cd
    ```
    kubectl port-forward -n argocd svc/argocd-server 8080:443
    ```