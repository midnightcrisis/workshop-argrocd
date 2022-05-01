### fluxcd

### get start
1. execute flux bootstrap 
  ```
  flux bootstrap git \
  --url=<FLUX_REPOSITORY_URL> \
  --branch=<BRANCH_NAME> \
  --path=<CLUSTER_PATH> \
  --private-key-file=<PRIVATE_KEY>
  ```
2. add repository
  ```
  flux create source git <NAME> \
  --url=https://github.com/stefanprodan/podinfo \
  --url=<APP_REPOSITORY_URL> \
  --branch=<BRANCH_NAME> \
  --interval=30s \
  --export > <CLUSTER_PATH>/source.yaml
  ```
3. deploy application
  ```
  flux create kustomization podinfo \
  --target-namespace=default \
  --source=podinfo \
  --path="./kustomize" \
  --prune=true \
  --interval=5m \
  --export > <CLUSTER_PATH>/kustomization.yaml
  ```

### setup notification
1. create webhook secret
  ```
  kubectl -n flux-system create secret generic slack-url --from-literal=address=https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK
  ```
2. create fluxcd notification provider
  ```
  apiVersion: notification.toolkit.fluxcd.io/v1beta1
  kind: Provider
  metadata:
    name: slack
    namespace: flux-system
  spec:
    type: slack
    channel: general
    secretRef:
      name: slack-url
  ```
3. define alert
  ```
  apiVersion: notification.toolkit.fluxcd.io/v1beta1
  kind: Alert
  metadata:
    name: on-call-webapp
    namespace: flux-system
  spec:
    providerRef:
      name: slack
    eventSeverity: info
    eventSources:
      - kind: GitRepository
        name: '*'
      - kind: Kustomization
        name: '*'
  ```