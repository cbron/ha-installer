#!/bin/bash

set -e

export KUBECONFIG=$(pwd)/kube_config_cluster.yml

kubectl get pods -o wide --all-namespaces

echo "installing helm"
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
kubectl -n kube-system rollout status deploy/tiller-deploy

echo "installing cert manager"
helm install stable/cert-manager  --name cert-manager  --namespace kube-system  --version v0.5.2
kubectl -n kube-system rollout status deploy/cert-manager


echo "installing rancher"

# # For custom helm or custom docker image use these commands from rancher dir
# helm install --dry-run ./chart -n rancher
# helm install ./chart -n rancher --namespace cattle-system --set hostname=localhost

# For stable rancher version use this
helm repo add rancher-latest https://releases.rancher.com/server-charts/stable
helm install rancher-latest/rancher --name rancher --namespace cattle-system --set hostname=localhost
kubectl -n cattle-system rollout status deploy/rancher

echo "exposing deployment"
# LB for local
kubectl -n cattle-system expose deployment rancher --name=lb443 --port 443 --target-port=443 --type=LoadBalancer  # you may want --port to be 8443 here to mimic local rancher setup
kubectl -n cattle-system get services lb443 
# Nodeport for cloud
kubectl get nodes
kubectl -n cattle-system expose deployment rancher --name=np443 --port 443 --target-port=443 --type=NodePort
kubectl -n cattle-system get services np443
echo "Hit the service by hitting the node's IP and node port"
