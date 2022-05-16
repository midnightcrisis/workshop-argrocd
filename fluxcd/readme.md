### fluxcd

## instal flux cli
- homebrew
  ```
  brew install fluxcd/tap/flux
  ```
- linux
  ```
  curl -s https://fluxcd.io/install.sh | sudo bash
  ```
- windows
  1. download binary `https://github.com/fluxcd/flux2/releases/download/v0.30.2/flux_0.30.2_windows_amd64.zip`
  2. unzip and copy binary to $PATH

### integrate fluxcd and kubernetes
1. generate ssh key to communicate between git server and kubernetes cluster
  ```
  ssh-keygen -t ed25519 -C "deploy"
  ```
2. add public key to git server
3. change kube context to cluster
4. run command to config git server and kubernetes cluster
  ```
  flux bootstrap git \
    --url=ssh://git@github.com/warapong-pj/workshop.git \
    --branch=feat/fluxcd/poc \
    --path=fluxcd/clusters/dev
  ```
5. add sealed-secret helm repository
  ```
  flux create source helm sealed-secrets \
    --interval=1h \
    --url=https://bitnami-labs.github.io/sealed-secrets
  ```

6. deploy sealed-secret to encrypt secret data
  ```
  flux create helmrelease sealed-secrets \
    --interval=1h \
    --release-name=sealed-secrets-controller \
    --target-namespace=flux-system \
    --source=HelmRepository/sealed-secrets \
    --chart=sealed-secrets \
    --chart-version="2.1.7" \
    --crds=CreateReplace
  ```

7. add stakater/reloader git source
  ```
  flux create source git reloader \
    --interval=1h \
    --tag="v0.0.110" \
    --url=https://github.com/stakater/Reloader.git
  ```

8. deploy stakater/reloader to reload application config
  ```
  flux create kustomization reloader \
    --target-namespace=reloader \
    --source=reloader \
    --path="./deployments/kubernetes" \
    --prune=true \
    --interval=5m
  ```

### note
- in case need to sync new cluster. we need to generate new secret to credential git server
  ```
  flux create secret git flux-system \
    --url=ssh://git@github.com/warapong-pj/workshop.git \
    --private-key-file=.ssh/id_rsa \
    --namespace=flux-system \
    --export > ./secret.yaml
  ```

### reference
- [fluxcd cli](https://fluxcd.io/docs/cmd/)