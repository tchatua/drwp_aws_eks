# Helm Chart Exploration - Retail UI

## Goals

- Pull an OCI chart and explore its source.
- `values.yaml` feeds into templates/ (and how to trace it).
- Lint and render charts locally before deploying.
- Confidence to read any Helm chart like source code, not a black box.

## Prerequisites

- Helm v3.8+ (OCI support)
- (Optional) tree or find, and grep (or rg/ripgrep if you have it)
- My custom values from earlier lab (e.g., values_ui.yml)

## Pull & Unpack the Chart (OCI → Local Folder)


```sh
# Create a workspace and enter it
# Pull the UI chart from ECR Public (OCI) and unpack it
helm pull oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.3.0 \
  --untar

# Inspect what got created
ls -la

# If you have 'tree':
tree -a || true
```

## Folder Structure

```sh
mv retail-store-sample-ui-chart ui

tree -s || true

└─ui/                                 # Root folder of the Helm chart
  ├── .helmignore                     # Files/directories to exclude when packaging the chart
  ├── Chart.yaml                      # Chart metadata: name, version, description, dependencies
  ├── README.md                       # Documentation for using this chart
  ├── templates/                      # All Kubernetes manifest templates (Go‑templated YAML)
  │   ├── NOTES.txt                   # Post‑install message shown after `helm install`
  │   ├── _helpers.tpl                # Helper template functions (naming, labels, common snippets)
  │   ├── configmap.yml               # Template for ConfigMap resources
  │   ├── deployment.yaml             # Template for the Deployment (pods, replicas, image, env)
  │   ├── hpa.yaml                    # Template for HorizontalPodAutoscaler
  │   ├── ingress.yaml                # Template for Ingress resource (if enabled)
  │   ├── istio-gateway.yml           # Istio Gateway definition (if using Istio)
  │   ├── istio-virtualservice.yml    # Istio VirtualService definition (traffic routing)
  │   ├── pdb.yaml                    # PodDisruptionBudget template
  │   ├── service.yaml                # Template for Kubernetes Service (ClusterIP/LB/NodePort)
  │   ├── serviceaccount.yaml         # Template for ServiceAccount (if enabled)
  │   └── tests/                      # Helm test definitions
  │       └── test-connection.yaml    # Test pod used by `helm test` to verify app connectivity
  └── values.yaml                     # Default configuration values used by all templates
```

## What each file does:

Typical Helm chart layout (names may vary slightly by publisher):

- `Chart.yaml` – Chart metadata: name, description, type, version (chart), appVersion (app).
- `values.yaml` – Default values shipped with the chart (what gets used when you don’t override).
- `.helmignore` – Files/paths excluded when packaging.
- `templates/` – Where the K8s YAML templates live:
  - `deployment.yaml` – Pod/ReplicaSet spec; references many .Values.* keys.
  - `service.yaml` – ClusterIP/LoadBalancer spec and ports.
  - `ingress.yaml` – Ingress rules and annotations (if supported).
  - `configmap.yml` (or similarly named) – App configuration rendered from values.
  - `_helpers.tpl` – Helper templates for names/labels (used across templates).
  - `NOTES.txt` – Post-install notes printed by Helm.
  - **Optional:** hpa.yaml, serviceaccount.yaml, tests/* (Helm test hooks), istio-*.yml.

**Tip:** Open values.yaml next to templates/. As you skim templates, note every .Values.* usage and where it maps in values.yaml.

## Discover the Available Knobs (Chart Defaults)

```sh
# See the chart’s default values directly from the registry (handy reference)
helm show values oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.3.0 | less
# ----------------------------------------------------------------------------------------------------------------------------------------
# Also inspect the local copy you just pulled:
cat ui/values.yaml
# ----------------------------------------------------------------------------------------------------------------------------------------
# (Optional) extra discovery
helm show chart  oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart --version 1.3.0
helm show readme oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart --version 1.3.0
```

## Lint & Render (No Cluster Needed)

If you’re not already in the charts/ folder, run:

```sh
cd charts
```

```sh
# Lint the chart templates (To validate the syntax)
helm lint ui
# ----------------------------------------------------------------------------------------------------------------------------------------
# Render the chart locally (defaults)
helm template ui ./ui | less
# ----------------------------------------------------------------------------------------------------------------------------------------
# Render with your custom values (adjust path if your repo differs)
helm template ui ./ui/ -f ./app_retailstore/values_ui.yml | less
# ----------------------------------------------------------------------------------------------------------------------------------------
# With custom values + extra debug
helm template ui ./ui/ -f ./app_retailstore/values_ui.yml --debug | less
```

> Outputs:

```sh
# To validate the syntax
helm lint ui/
==> Linting ui/
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, 0 chart(s) failed
```

## Install Locally From the Unpacked Chart

```sh
# If needed, enter the charts directory
# Install with a different release name to avoid clobbering your previous demo
# helm install ui-local ./ui -f ../retailstore-apps/values-ui.yaml
helm install ui-local ui/
# ----------------------------------------------------------------------------------------------------------------------------------------
# Check what got created
# helm status ui-local --show-resources
helm status ui-local
kubectl get pods,svc,ing
```

> Outputs

```sh
helm install ui-local ui/

NAME: ui-local
LAST DEPLOYED: Sat Jun 20 11:23:18 2026
NAMESPACE: default
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=ui,app.kubernetes.io/instance=ui-local" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace default port-forward $POD_NAME 8080:80

# ----------------------------------------------------------------------------------------------------------------------------------------

helm status ui-local

NAME: ui-local
LAST DEPLOYED: Sat Jun 20 11:23:18 2026
NAMESPACE: default
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
RESOURCES:
==> v1/ServiceAccount
NAME       SECRETS   AGE
ui-local   0         97s

==> v1/ConfigMap
NAME       DATA   AGE
ui-local   0      97s

==> v1/Service
NAME       TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
ui-local   ClusterIP   172.20.47.45   <none>        80/TCP    97s

==> v1/Deployment
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
ui-local   1/1     1            1           97s

==> v1/Pod(related)
NAME                       READY   STATUS    RESTARTS   AGE
ui-local-67b878969-bvtd9   1/1     Running   0          97s


NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=ui,app.kubernetes.io/instance=ui-local" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace default port-forward $POD_NAME 8080:80


# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl  port-forward svc/ui-local 30080:80

Forwarding from 127.0.0.1:30080 -> 8080
Forwarding from [::1]:30080 -> 8080
Handling connection for 30080
Handling connection for 30080
Handling connection for 30080
Handling connection for 30080
# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl get pods,svc,ing
NAME                           READY   STATUS    RESTARTS   AGE
pod/ui-local-67b878969-bvtd9   1/1     Running   0          6m18s

NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   172.20.0.1     <none>        443/TCP   17h
service/ui-local     ClusterIP   172.20.47.45   <none>        80/TCP    6m18s
```

## Quick Value Change (Theme → orange)

I’ll make a small change in values-ui.yaml and see it reflected in the rendered manifests (and optionally in a running release).

```yaml
app:
  theme: orange
```

edit `./app_retailstore/values_ui.yml` to above

> Re-render locally (no cluster needed)

```sh
helm template ui ./ui/ -f ./app_retailstore/values_ui.yml | less
# ----------------------------------------------------------------------------------------------------------------------------------------
# See where theme appears
helm template ui ./ui/ -f ./app_retailstore/values_ui.yml | grep -ni theme
```

> Outputs

```sh
helm template ui ./ui/ -f ./app_retailstore/values_ui.yml | grep -ni theme
21:  RETAIL_UI_THEME: orange
```

## Apply to a running release from the local chart

```sh
# Install/upgrade a local test release
helm upgrade --install ui-local ./ui/ -f ./app_retailstore/values_ui.yml
# ----------------------------------------------------------------------------------------------------------------------------------------
# Verify the effective values
helm get values ui-local --all
helm get values ui-local --all | grep theme
# ----------------------------------------------------------------------------------------------------------------------------------------
# List pods
kubectl get pods
```

> Outputs

```sh
helm upgrade --install ui-local ./ui/ -f ./app_retailstore/values_ui.yml
Release "ui-local" has been upgraded. Happy Helming!
NAME: ui-local
LAST DEPLOYED: Sat Jun 20 11:52:52 2026
NAMESPACE: default
STATUS: deployed
REVISION: 2
DESCRIPTION: Upgrade complete
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=ui,app.kubernetes.io/instance=ui-local" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace default port-forward $POD_NAME 8080:80

# ----------------------------------------------------------------------------------------------------------------------------------------

helm get values ui-local --all | grep theme
  theme: orange

# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl get pods
NAME                       READY   STATUS    RESTARTS   AGE
ui-local-67b878969-bvtd9   1/1     Running   0          31m
```

If pods don’t restart automatically (some charts put theme into a ConfigMap/env without changing the pod template), do a quick restart:

```sh
# Restart pods reliably via release label (works across naming templates)
kubectl rollout restart deploy -l app.kubernetes.io/instance=ui-local

# Verify
kubectl get pods
```

> Outputs

```sh
kubectl rollout restart deploy -l app.kubernetes.io/instance=ui-local
deployment.apps/ui-local restarted

# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
ui-local-5cbf675fff-pnjld   1/1     Running   0          92s
```

## Helm Tests (If the Chart Ships Them)

- Some charts include test hooks under templates/tests/*.
- In our chart, we have templates/tests/test-connection.yaml.

```sh
# Helm test
helm test ui-local
```

> Outputs

```sh
helm list
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                       APP VERSION
ui-local        default         2               2026-06-20 11:52:52.3528133 -0400 EDT   deployed        retail-store-sample-ui-chart-1.3.0

# ----------------------------------------------------------------------------------------------------------------------------------------

helm test ui-local

NAME: ui-local
LAST DEPLOYED: Sat Jun 20 11:52:52 2026
NAMESPACE: default
STATUS: deployed
REVISION: 2
DESCRIPTION: Upgrade complete
TEST SUITE:     ui-local-test-connection
Last Started:   Sat Jun 20 12:04:50 2026
Last Completed: Sat Jun 20 12:04:53 2026
Phase:          Succeeded
```

## Uninstall ui-local Helm Release

```sh
# Uninstall
helm uninstall ui-local
```

## Handy Reference Commands (Cheat-Sheet)

```sh
# Pull (OCI) + unpack
helm pull oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart --version 1.3.0 --untar

# Show chart metadata & defaults from registry
helm show chart  oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart --version 1.3.0
helm show values oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart --version 1.3.0
helm show readme oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart --version 1.3.0

# Lint + render from local source
helm lint ui
helm template ui ./ui -f ../retailstore-apps/values-ui.yaml --debug

# Install from local source (separate release name)
helm install ui-local ./ui -f ../app_retailstore/values-ui.yaml
helm status ui-local --show-resources
```
