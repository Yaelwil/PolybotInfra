#!/bin/bash

# On the worker node-

"""
SCP the files-
cluster-configs.yaml
ebs-csi-values.yaml

scp -i ~/yaelwil-ohio.pem cluster-configs.yaml ebs-csi-values.yaml ubuntu@ip:~/

run on the control plane-

sudo kubeadm init --config cluster-configs.yaml

kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
kubectl apply -k 'github.com/kubernetes/cloud-provider-aws/examples/existing-cluster/base/?ref=master'
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm repo update
helm upgrade --install aws-ebs-csi-driver -f ebs-csi-values.yaml -n kube-system aws-ebs-csi-driver/aws-ebs-csi-driver
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.1/deploy/static/provider/aws/deploy.yaml
"""