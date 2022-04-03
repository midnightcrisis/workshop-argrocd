### argo cd
1. create argocd namespace
    ```
    kubectl create namespace argocd
    ```
2. deploy argo cd with extension to namespace argocd
    ```
    kubectl apply -k argo/ -n argocd
    ```

### note
- to get initial argocd password
    ```
    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
    ```