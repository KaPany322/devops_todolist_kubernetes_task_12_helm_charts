# Django ToDo list

This is a to-do list web application with the basic features of most web apps, i.e., accounts/login, API, and interactive UI. To do this task, you will need:

- CSS | [Skeleton](http://getskeleton.com/)
- JS  | [jQuery](https://jquery.com/)

## Explore

Try it out by installing the requirements (the following commands work only with Python 3.8 and higher, due to Django 4):

```
pip install -r requirements.txt
```

Create a database schema:

```
python manage.py migrate
```

And then start the server (default is http://localhost:8000):

```
python manage.py runserver
```

You can now browse the [API](http://localhost:8000/api/) or start on the [landing page](http://localhost:8000/).

## Run the app on Kubernetes with Kind

The repository includes a Helm chart for the ToDo app and its MySQL sub-chart. With Docker running and `kind`, `kubectl`, and Helm installed, run the bootstrap script from the repository root:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

The script creates the `kind` cluster if needed, prepares the MySQL worker nodes, installs the ingress-nginx controller, and installs or upgrades the Helm release. The app is available at <http://localhost:30007>.

To apply chart changes directly, use:

```bash
helm upgrade --install todoapp-release .infrastructure/helm-chart/todoapp \
  --namespace todoapp --create-namespace --wait --timeout 5m
```

See [INSTRUCTION.md](INSTRUCTION.md) for deployment checks, troubleshooting commands, and how to refresh `output.log`.

## Task

Create a Kubernetes manifest for a pod that will contain a ToDo app container:

1. Fork this repository.
1. Use `kind` to spin up a cluster from a `cluster.yml` configuration file.
1. Inspect Nodes for Labels and Taints
1. Taint nodes labeled with `app=mysql` with `app=mysql:NoSchedule`
1. Create a helm chart named `todoapp` inside a `helm-chart` directory
1. `todoapp` helm chart requirements:
    1. Namespace name should be controlled from a `values.yaml` file
    1. Use `.Chart.Name` as a prefix for all resources names
    1. Secrets should be controlled from a `values.yaml` file
    1. Secrets `data` should be popualted by a `range` function
    1. Inside the deployment use `range` to map secrets as environment variables
    1. Resources requests and limits should controlled from a `values.yaml` file
    1. RollingUpdate parameters should be controlled from a `values.yaml` file
    1. Image repository and tag should be controlled from a `values.yaml` file
    1. Deployment node affinity parameters should be controlled from a `values.yaml` file (key and values)
    1. `hpa` min and max replicas should be controlled from a `values.yaml` file
    1. `hpa` average CPU and Memory utilization should be controlled from a `values.yaml` file
    1. `pv` capacity should be controlled from a `values.yaml` file
    1. `pvc` requests storage should be controlled from a `values.yaml` file
    1. Service Account Name inside both `Deployment` and all rbac objects should be controlled from a `values.yaml` file
1. Create a sub-chart called `mysql` inside a `charts` directory of the `todoapp` helm chart
1. `mysql` helm chart requirements:
    1. Namespace name should be controlled from a `values.yaml` file
    1. Use `.Chart.Name` as a prefix for all resource names
    1. Secrets should be controlled from a `values.yaml` file
    1. Secrets `data` should be populated by a `range` function
    1. StateFulSet's Replicas should be controlled from a `values.yaml` file
    1. Image repository and tag should be controlled from a `values.yaml` file
    1. `pvc` requests storage should be controlled from a `values.yaml` file
    1. Affinity and Toleration parameters should be controlled from a `values.yaml` file
    1. Resource requests and limits should controlled from a `values.yaml` file
1. Add explicit dependencies between `todoapp` and `mysql` charts
    1. Inside the `Chart.yaml` file of todoapp chart, add lines
        ```
        dependencies:
        - name: mysql
        ```

10. `bootstrap.sh` should contain all commands to deploy prerequisites and the `todoapp` helm chart
11. Deploy the helm chart to your `kind` cluster
11. Run the command `kubectl get all,cm,secret,ing -A` and put the output in a file called `output.log` in the root of the repository
12. Create the `INSTRUCTION.md` file with instructions on how to validate the changes
13. Create PR with your changes and attach it for validation on a platform.
