# Package & Publish Retail UI Helm Chart (ECR Private)

In this Lab, I will package, publish, install, and verify a Helm chart for the Retail Store UI Application using Amazon ECR Private by:

- Update chart metadata (Chart.yaml)
- Package Helm chart (.tgz)
- Push to Amazon ECR Private (OCI registry)
- Install Helm chart directly from ECR
- Understand image tag fallback (.Chart.Version)
- New: Release Info ConfigMap

## Pre-requisite

```sh
# Create a workspace and enter it
mkdir -p charts && cd charts
# ----------------------------------------------------------------------------------------------------------------------------------------
# Pull the UI chart from ECR Public (OCI) and unpack it
helm pull oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.3.0 \
  --untar
# ----------------------------------------------------------------------------------------------------------------------------------------
# Inspect what got created
ls -la  
# ----------------------------------------------------------------------------------------------------------------------------------------
# Rename the long folder name to smaller folder name
mv retail-store-sample-ui-chart ui
# ----------------------------------------------------------------------------------------------------------------------------------------
# If you have 'tree':
tree -a || true

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

## UI Helm Chart Updates

Edit Chart.yaml inside your chart (ui/):

```yaml
apiVersion: v2
description: Helm chart for the AWS Retail Store Sample Application UI service
  service
name: retail-store-sample-ui-chart
type: application
version: 1.3.1    # Updated chart version (bump from 1.3.0 to 1.3.1)
```

Always bump version when releasing a new chart.

## Add Release Info ConfigMap

Create a new template file: templates/release-info.yaml

```yaml
{{- if .Values.releaseInfo.enabled }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "ui.fullname" . }}-release-info
  labels:
    {{- include "ui.labels" . | nindent 4 }}
data:
  chartName: "{{ .Chart.Name }}"
  chartVersion: "{{ .Chart.Version }}"
  appVersion: "{{ .Chart.AppVersion }}"
  releaseName: "{{ .Release.Name }}"
  releaseNamespace: "{{ .Release.Namespace }}"
  releaseRevision: "{{ .Release.Revision }}"
  releaseTime: "{{ now | date "2006-01-02T15:04:05Z07:00" }}"
{{- end }}
```

```sh
touch ui/templates/release-info.yaml

```

## Add defaults in ui/values.yaml

```yaml
# Add overrides in ui/values-ui.yaml
releaseInfo:
  enabled: false # Set it as true
```

## 

```yaml

```


```sh
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
  │   ├── release-info.yaml                
  │   ├── service.yaml                # Template for Kubernetes Service (ClusterIP/LB/NodePort)
  │   ├── serviceaccount.yaml         # Template for ServiceAccount (if enabled)
  │   └── tests/                      # Helm test definitions
  │       └── test-connection.yaml    # Test pod used by `helm test` to verify app connectivity
  └── values.yaml                     # Default configuration values used by all templates
```

## End-to-End Workflow

- Create AWS ECR Private repository
- helm package
- helm push

```sh
# Set Variables
REGION=us-east-2
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGISTRY="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"

# Verify Variables
echo $REGION
echo $ACCOUNT_ID
echo $REGISTRY

# Login to ECR for Helm/OCI
aws ecr get-login-password --region "$REGION" \
| helm registry login -u AWS --password-stdin "$REGISTRY"

# Create flat repo (exactly chart name)
aws ecr create-repository \
  --repository-name retail-store-sample-ui-chart \
  --region "$REGION" || true

# Package chart (matches Chart.yaml)
helm package ./ui   # -> retail-store-sample-ui-chart-1.3.1.tgz

# Push to ECR (OCI): IMPORTANT: push to registry root (no suffix) ---
helm push retail-store-sample-ui-chart-1.3.1.tgz oci://"$REGISTRY"

# Verify
aws ecr describe-images \
  --repository-name retail-store-sample-ui-chart \
  --region "$REGION" \
  --query 'imageDetails[].imageTags'
```

> Outputs

```sh
# Login to ECR for Helm/OCI
aws ecr get-login-password --region "$REGION" \
| helm registry login -u AWS --password-stdin "$REGISTRY"

Login Succeeded

# ----------------------------------------------------------------------------------------------------------------------------------------

ll
total 4
drwxr-xr-x 1 tchat 197609 0 Jun 20 12:53 ui/

# ----------------------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------------------
helm package ./ui/
Successfully packaged chart and saved it to: C:\Users\tchat\OneDrive\Documents\2026\a09_Platform_Engineer\a04_Udemy\a13_Ultimate_DevOps_Real_World_Project_on_AWS_Cloud\drwp_aws_eks\h04_helm_package_and_publish\charts\retail-store-sample-ui-chart-1.3.1.tgz

# ----------------------------------------------------------------------------------------------------------------------------------------
ll
total 12
-rw-r--r-- 1 tchat 197609 7076 Jun 20 13:37 retail-store-sample-ui-chart-1.3.1.tgz
drwxr-xr-x 1 tchat 197609    0 Jun 20 12:53 ui/

# ----------------------------------------------------------------------------------------------------------------------------------------

helm push retail-store-sample-ui-chart-1.3.1.tgz oci://"$REGISTRY"
Pushed: 088354478627.dkr.ecr.us-east-2.amazonaws.com/retail-store-sample-ui-chart:1.3.1
Digest: sha256:2ed7b702055a42bb20f2ef7a753dfcc66bb3d64f00387dd9b7b1633393c2eb24

# ----------------------------------------------------------------------------------------------------------------------------------------

aws ecr describe-images \
  --repository-name retail-store-sample-ui-chart \
  --region "$REGION" \
  --query 'imageDetails[].imageTags'
[
    [
        "1.3.1"
    ]
]
```

## Install Chart from ECR Private

```sh
# helm install
helm install retail-ui \
  oci://"$REGISTRY"/retail-store-sample-ui-chart \
  --version 1.3.1 \
  -f ../app_retailstore/values-ui.yml
```

> Outputs

```sh
helm install retail-ui \
  oci://"$REGISTRY"/retail-store-sample-ui-chart \
  --version 1.3.1 \
  -f ../app_retailstore/values-ui.yml

Pulled: 088354478627.dkr.ecr.us-east-2.amazonaws.com/retail-store-sample-ui-chart:1.3.1
Digest: sha256:2ed7b702055a42bb20f2ef7a753dfcc66bb3d64f00387dd9b7b1633393c2eb24
NAME: retail-ui
LAST DEPLOYED: Sat Jun 20 14:02:25 2026
NAMESPACE: default
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=ui,app.kubernetes.io/instance=retail-ui" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace default port-forward $POD_NAME 8080:80
```

> Or updates:

```sh
# helm upgrade
helm upgrade --install retail-ui \
  oci://"$REGISTRY"/retail-store-sample-ui-chart \
  --version 1.2.5 \
  -f ../retailstore-apps/values-ui.yml
```

```sh
kubectl get ingress
NAME        CLASS   HOSTS   ADDRESS                                                                 PORTS   AGE
retail-ui   alb     *       k8s-default-retailui-2cdac2744f-424936419.us-east-2.elb.amazonaws.com   80      6m33s

# ----------------------------------------------------------------------------------------------------------------------------------------

helm list

NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                       APP VERSION
retail-ui       default         1               2026-06-20 14:02:25.4783836 -0400 EDT   deployed        retail-store-sample-ui-chart-1.3.1

# ----------------------------------------------------------------------------------------------------------------------------------------
helm status retail-ui

NAME: retail-ui
LAST DEPLOYED: Sat Jun 20 14:02:25 2026
NAMESPACE: default
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
RESOURCES:
==> v1/ServiceAccount
NAME        SECRETS   AGE
retail-ui   0         29m

==> v1/ConfigMap
NAME        DATA   AGE
retail-ui   1      29m
retail-ui-release-info   7     29m

==> v1/Service
NAME        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
retail-ui   ClusterIP   172.20.36.188   <none>        80/TCP    29m

==> v1/Deployment
NAME        READY   UP-TO-DATE   AVAILABLE   AGE
retail-ui   1/1     1            1           29m

==> v1/Pod(related)
NAME                         READY   STATUS    RESTARTS   AGE
retail-ui-594c7cdc85-7tpkx   1/1     Running   0          29m

==> v1/Ingress
NAME        CLASS   HOSTS   ADDRESS                                                                 PORTS   AGE
retail-ui   alb     *       k8s-default-retailui-2cdac2744f-424936419.us-east-2.elb.amazonaws.com   80      29m


NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=ui,app.kubernetes.io/instance=retail-ui" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace default port-forward $POD_NAME 8080:80

# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl get cm retail-ui-release-info -o yaml

apiVersion: v1
data:
  appVersion: ""
  chartName: retail-store-sample-ui-chart
  chartVersion: 1.3.1
  releaseName: retail-ui
  releaseNamespace: default
  releaseRevision: "1"
  releaseTime: "2026-06-20T14:02:25-04:00"
kind: ConfigMap
metadata:
  annotations:
    meta.helm.sh/release-name: retail-ui
    meta.helm.sh/release-namespace: default
  creationTimestamp: "2026-06-20T18:02:29Z"
  labels:
    app.kubernetes.io/component: service
    app.kubernetes.io/instance: retail-ui
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: ui
    app.kubernetes.io/owner: retail-store-sample
    helm.sh/chart: ui-1.3.1
  name: retail-ui-release-info
  namespace: default
  resourceVersion: "291657"
  uid: c4dd62e7-274c-42bf-86d9-900708492ccf
```

## Important Note on Deployment & Image Tags

The Deployment template defines the container image like this:

```yml
image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.Version }}"
```

Meaning:

- If I set `image.tag`, that tag is used.
- I you don’t set it, Helm falls back to `.Chart.Version`.
Best Practice: Always set `image.repository` and `image.tag` explicitly.

Example (values-ui.yaml):

```yml
# Add Image and Tag
image:
  repository: public.ecr.aws/aws-containers/retail-store-sample-ui
  pullPolicy: IfNotPresent
  tag: 1.3.0   
```

https://gallery.ecr.aws/aws-containers/retail-store-sample-ui


## Verify Resources


```sh
# List Helm Releases
helm list
# ----------------------------------------------------------------------------------------------------------------------------------------
# List Kubernetes Resources
helm status retail-ui --show-resources 

# Verify pods & service
kubectl get pods,svc
# ----------------------------------------------------------------------------------------------------------------------------------------
# Verify Release Info ConfigMap
kubectl get cm 
kubectl get cm retail-ui-release-info -o yaml
kubectl describe cm retail-ui-release-info
```

## Cleanup

```sh
helm uninstall retail-ui
```

> Output

```sh
helm uninstall retail-ui
release "retail-ui" uninstalled
```

## Cleanup ECR Repository (Optional)

```sh
# Delete AWS ECR Repository
aws ecr delete-repository \
  --repository-name retail-store-sample-ui-chart \
  --region "$REGION" \
  --force
```

> Output

```sh
aws ecr delete-repository \
  --repository-name retail-store-sample-ui-chart \
  --region "$REGION" \
  --force
{
    "repository": {
        "repositoryArn": "arn:aws:ecr:us-east-2:088354478627:repository/retail-store-sample-ui-chart",
        "registryId": "088354478627",
        "repositoryName": "retail-store-sample-ui-chart",
        "repositoryUri": "088354478627.dkr.ecr.us-east-2.amazonaws.com/retail-store-sample-ui-chart",
        "createdAt": "2026-06-20T13:25:31.650000-04:00",
        "imageTagMutability": "MUTABLE"
    }
}
```

Use --force to delete the repo along with all images (chart versions) inside it.


## Summary

- Packaged Retail UI Helm Chart v1.3.1
- Published to Amazon ECR Private
- Installed directly from ECR
- Verified new Release Info ConfigMap
- Learned about image tag fallback (.Chart.Version)
Note: This completes the real-world Helm packaging & publishing workflow on AWS.

