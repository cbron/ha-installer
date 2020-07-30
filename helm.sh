#!/bin/bash

set -e

export KUBECONFIG=$(pwd)/kube_config_cluster.yml

kubectl get pods -o wide --all-namespaces


echo "installing helm"

kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
## this is for helm 2
# helm init --service-account tiller
# kubectl -n kube-system rollout status deploy/tiller-deploy



echo "installing cert manager"

# For cert manager on older kube
# helm3 install stable/cert-manager  --name cert-manager  --namespace kube-system  --version v0.5.2
# kubectl -n kube-system rollout status deploy/cert-manager

# For cert manager in newer kube
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests/00-crds.yaml
kubectl create namespace cert-manager
helm3 repo add jetstack https://charts.jetstack.io
helm3 repo update
helm3 install cert-manager jetstack/cert-manager --namespace cert-manager --version v0.12.0
kubectl -n cert-manager rollout status deploy/cert-manager



echo "installing rancher"

# For custom helm or custom docker image use these commands from rancher dir
# with chart.yaml version and appVersion as 'latest', chart.values rancherImage as your image,
# and rancherImagePullPolicy set to always.
# helm3 install --dry-run ./chart -n rancher
# helm3 install ./chart -n rancher --namespace cattle-system --set hostname=localhost


# # For stable rancher version use this
# helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
# helm install rancher-stable/rancher --name rancher --namespace cattle-system --set hostname=cbron.do.rancher.space
# kubectl -n cattle-system rollout status deploy/rancher

# OR for custom image
helm3 repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm3 repo update
helm3 install rancher rancher-latest/rancher --namespace cattle-system --create-namespace --set hostname=cbron.do.rancher.space --set rancherImageTag=master-head  --set rancherImagePullPolicy=Always
kubectl -n cattle-system rollout status deploy/rancher

echo "exposing deployment"

# # LB for local
# kubectl -n cattle-system expose deployment rancher --name=lb443 --port 443 --target-port=443 --type=LoadBalancer  # you may want --port to be 8443 here to mimic local rancher setup
# kubectl -n cattle-system get services lb443

# Nodeport for cloud
kubectl -n cattle-system expose deployment rancher --name=np443 --port 443 --target-port=443 --type=NodePort
kubectl -n cattle-system get services np443
echo "Hit the service by hitting the node's IP and node port"
