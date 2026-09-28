# Validate the Kubernetes deployment

## Create or update the app

From the repository root, run:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

To apply a chart change without rerunning the cluster setup, run:

```bash
helm upgrade --install todoapp-release .infrastructure/helm-chart/todoapp \
  --namespace todoapp --create-namespace --wait --timeout 5m
```

## Check the deployment

Check that the application and database pods are ready:

```bash
kubectl get pods -n todoapp
kubectl get pods -n mysql
```

Check the application service and ingress:

```bash
kubectl get svc,ing -n todoapp
```

If a pod is not ready, inspect its events and logs:

```bash
kubectl describe pods -n todoapp
kubectl logs -n todoapp deployment/todoapp-release-todoapp
kubectl describe pods -n mysql
kubectl logs -n mysql statefulset/mysql
```
