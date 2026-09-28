#!/usr/bin/env bash
set -Eeuo pipefail

CLUSTER_NAME="kind"
RELEASE_NAME="todoapp-release"
APP_NAMESPACE="todoapp"

# Create the local Kind cluster once; later runs reuse it.
if ! kind get clusters | grep -qx "$CLUSTER_NAME"; then
  kind create cluster --name "$CLUSTER_NAME" --config "$ROOT_DIR/cluster.yml"
fi

kubectl config use-context "kind-${CLUSTER_NAME}"
kubectl wait --for=condition=Ready nodes --all --timeout=180s

# MySQL's chart schedules database pods only onto these tainted worker nodes.
kubectl taint nodes -l app=mysql app=mysql:NoSchedule --overwrite

# Install the ingress controller required by the chart's Ingress resource.
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl rollout status deployment/ingress-nginx-controller \
  --namespace ingress-nginx --timeout=180s

# The chart creates the MySQL namespace and all app/database resources.
helm upgrade --install "$RELEASE_NAME" "$ROOT_DIR/.infrastructure/helm-chart/todoapp" \
  --namespace "$APP_NAMESPACE" --create-namespace \
  --wait --timeout 5m
