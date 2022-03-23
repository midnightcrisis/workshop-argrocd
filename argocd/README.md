### Install Argo CD
1. kubectl create ns argocd
2. kubectl apply -k . -n argocd
3. kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
4. kubectl port-forward -n argocd svc/argocd-server 8080:443
5. argocd login localhost:8080
6. argocd account update-password

### Deploy Application
1. argocd app create sample --repo https://gitlab.com/warapong.pj/workshop.git --revision develop --path base/sample --dest-server https://kubernetes.default.svc --dest-namespace default
2. get application on argocd `argocd app get sample`
3. sync manifest file `argocd app sync sample`
4. check history `argocd app history sample`
5. rollback `argocd app rollback sample 1`
4. delete application `argocd app delete sample`