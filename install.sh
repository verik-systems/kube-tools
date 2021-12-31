#!/bin/sh

set -e

apk add --update py3-pip curl make openssl groff wget

# install kubectl
curl -L "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl
chmod +x /usr/local/bin/kubectl
kubectl version --client

# install Helm
# https://helm.sh/docs/intro/install/#from-script
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sh

# install eksctl 
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl /usr/local/bin

# install YAML tools
pip install yamllint yq

# cleanup
rm /var/cache/apk/*
rm -rf /tmp/*
