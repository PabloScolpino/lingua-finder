# 1. Configure access to the k8s cluster

    # Get the kube.cfg file to access the cluster
    # select the right cluster, if many are configured locally
    kubectx

# 2 Recomended tools

* kubectx (kube config administrator)

      brew install kubectx

* krew (kubectl plugin manager)

      brew install krew
      # edit .bashrc/.zshrc following instructions

* kubectl-view-secret (kubectl plugin)

      kubectl krew install view-secret


* kubectl-modify-secret (kubectl plugin)

      kubectl krew install modify-secret


# 3. create the namespace

    kubectl create namespace lingua-finder

# 4. Secrets

## 4.1 Create base secret

    ./generate_secret.sh


## 4.2. Edit the secrets

    kubectl get secret --namespace lingua-finder

    kubectl view-secret lingua-finder --all --namespace lingua-finder

    kubectl modify-secret lingua-finder --namespace lingua-finder

## 4.3 Additional necesary secrets

    GOOGLE_API_KEY: a-key
    GOOGLE_SEARCH_CX: a-search-cx
    OA2_GOOGLE_CLIENT_ID: a-client-id
    OA2_GOOGLE_CLIENT_SECRET: a-secret

# 5. Install the application

    helm install lf ./lingua-finder --namespace=lingua-finder

# 6. run inside the pod

    export POD_NAME=$(kubectl get pods --namespace lingua-finder -l "app.kubernetes.io/name=lingua-finder,app.kubernetes.io/instance=lf" -o jsonpath="{.items[0].metadata.name}")
    kubectl exec --stdin --tty $POD_NAME --namespace=lingua-finder -- /bin/sh
    kubectl exec --stdin --tty $POD_NAME --namespace=lingua-finder -- bundle exec rails console

# 7. Upgrade the application

    helm upgrade lf ./lingua-finder --namespace=lingua-finder
