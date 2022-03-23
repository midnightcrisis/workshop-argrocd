### Install Argo CD
1. kubectl create ns argocd
2. kubectl apply -k . -n argocd
3. kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
4. kubectl port-forward -n argocd svc/argocd-server 8080:443
5. argocd login localhost:8080
6. argocd account update-password

### Note
- kubectl patch crd/argocdextensions.argoproj.io -p '{"metadata":{" ":[]}}' --type=merge
