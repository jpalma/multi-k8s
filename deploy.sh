apk update  && apk add --no-cache curl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl
mkdir -p $HOME/.kube
echo -n $KUBE_CONFIG | base64 -d > $HOME/.kube/config
kubectl create secret docker-registry gitlab-registry --docker-server="$CI_REGISTRY" --docker-username="$CI_DEPLOY_USER" --docker-password="$CI_DEPLOY_PASSWORD" --docker-email="$GITLAB_USER_EMAIL" -o yaml --dry-run=client
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=$CI_REGISTRY_IMAGE/multi-server:$CI_COMMIT_SHORT_SHA
kubectl set image deployments/client-deployment client=$CI_REGISTRY_IMAGE/multi-client:$CI_COMMIT_SHORT_SHA
kubectl set image deployments/worker-deployment worker=$CI_REGISTRY_IMAGE/multi-worker:$CI_COMMIT_SHORT_SHA
