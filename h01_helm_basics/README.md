# Helm Bsics

Using helm basics on my Store UI Application.

- install a Helm chart from OCI
- list and inspect Helm releases
- upgrade and rollback Helm releases
- override application values
- view chart values and rendered manifests
- uninstall a release

- URLS:
    - https://artifacthub.io/

```sh
aws eks update-kubeconfig \
  --region us-east-2 \
  --name south-jersey-eks-tchatua-dev-eks-control-plane
Updated context arn:aws:eks:us-east-2:088354478627:cluster/south-jersey-eks-tchatua-dev-eks-control-plane in C:\Users\tchat\.kube\config

# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl get all
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   172.20.0.1   <none>        443/TCP   4h43m
```


## Explore Helm Chart Source

By default, the chart installs with its own service configuration.


```sh
helm version
version.BuildInfo{Version:"v4.1.4", GitCommit:"05fa37973dc9e42b76e1d2883494c87174b6074f", GitTreeState:"clean", GoVersion:"go1.25.9", KubeClientVersion:"v1.35"}

# ----------------------------------------------------------------------------------------------------------------------------------------

# Authenticate to Public ECR
## Helm needs a valid authentication token to pull OCI charts from Amazon ECR Public.
aws ecr-public get-login-password --region us-east-1 | helm registry login -u AWS --password-stdin public.ecr.aws
# When failed
# ----------------------------------------------------------------------------------------------------------------------------------------
# Troubleshooting
# ----------------------------------------------------------------------------------------------------------------------------------------
%USERPROFILE%\.docker\config.json

# ----------------------------------------------------------------------------------------------------------------------------------------

{
  "auths": {
    "https://index.docker.io/v1/": {},
    "https://index.docker.io/v1/access-token": {},
    "https://index.docker.io/v1/refresh-token": {}
  },
  "credsStore": "",
  "currentContext": "desktop-linux"
}

# -----

#-----------------------------------------------------------------------------------------------------------------------------------
# Use xcmd.exe
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws

WARNING! Your credentials are stored unencrypted in 'C:\Users\tchat\.docker\config.json'.
Configure a credential helper to remove this warning. See
https://docs.docker.com/go/credential-store/

Login Succeeded

# --------
$TOKEN = aws ecr-public get-login-password --region us-east-1
helm registry login public.ecr.aws -u AWS --password $TOKEN

#--------------------------------------------------------------------------------------------------------------------------------

# Install Retail UI Helm Chart (version 1.0.0)
helm install ui oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.6.1

Pulled: public.ecr.aws/aws-containers/retail-store-sample-ui-chart:1.6.1
Digest: sha256:efa886f13f1157735a085b338b7d1fd764614d338f53d5454b4cc765411ab933
NAME: ui
LAST DEPLOYED: Fri Jun 19 18:35:34 2026
NAMESPACE: default
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=ui,app.kubernetes.io/instance=ui" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace default port-forward $POD_NAME 8080:80

# ----------------------------------------------------------------------------------------------------------------------------------------

export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=ui,app.kubernetes.io/instance=ui" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace default port-forward $POD_NAME 8080:80

# ----------------------------------------------------------------------------------------------------------------------------------------

helm list
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                                   APP VERSION
ui      default         1               2026-06-19 14:35:59.3221873 -0400 EDT   deployed        retail-store-sample-ui-chart-1.6.1

# ----------------------------------------------------------------------------------------------------------------------------------------

helm list -A
NAME                            NAMESPACE       REVISION        UPDATED
                STATUS          CHART                                           APP VERSION
aws-load-balancer-controller    kube-system     1               2026-06-19 09:49:24.4416293 -0400 EDT deployed        aws-load-balancer-controller-3.4.0              v3.4.0

csi-secrets-store               kube-system     1               2026-06-19 09:49:23.2222871 -0400 EDT deployed        secrets-store-csi-driver-1.6.0                  1.6.0

secrets-provider-aws            kube-system     1               2026-06-19 09:49:44.7924957 -0400 EDT deployed        secrets-store-csi-driver-provider-aws-3.1.1

ui                              default         1               2026-06-19 14:35:59.3221873 -0400 EDT deployed        retail-store-sample-ui-chart-1.6.1



# ----------------------------------------------------------------------------------------------------------------------------------------

helm list --output=yaml
- app_version: ""
  chart: retail-store-sample-ui-chart-1.6.1
  name: ui
  namespace: default
  revision: "1"
  status: deployed
  updated: 2026-06-19 14:35:59.3221873 -0400 EDT

# ----------------------------------------------------------------------------------------------------------------------------------------

helm list -A --output=yaml
- app_version: v3.4.0
  chart: aws-load-balancer-controller-3.4.0
  name: aws-load-balancer-controller
  namespace: kube-system
  revision: "1"
  status: deployed
  updated: 2026-06-19 09:49:24.4416293 -0400 EDT
- app_version: 1.6.0
  chart: secrets-store-csi-driver-1.6.0
  name: csi-secrets-store
  namespace: kube-system
  revision: "1"
  status: deployed
  updated: 2026-06-19 09:49:23.2222871 -0400 EDT
- app_version: ""
  chart: secrets-store-csi-driver-provider-aws-3.1.1
  name: secrets-provider-aws
  namespace: kube-system
  revision: "1"
  status: deployed
  updated: 2026-06-19 09:49:44.7924957 -0400 EDT
- app_version: ""
  chart: retail-store-sample-ui-chart-1.6.1
  name: ui
  namespace: default
  revision: "1"
  status: deployed
  updated: 2026-06-19 14:35:59.3221873 -0400 EDT

# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl get svc
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   172.20.0.1      <none>        443/TCP   5h53m
ui           ClusterIP   172.20.22.117   <none>        80/TCP    63m

# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl get deploy
NAME   READY   UP-TO-DATE   AVAILABLE   AGE
ui     1/1     1            1           63m

# ----------------------------------------------------------------------------------------------------------------------------------------
```

## 👉 By default, the Retail UI chart exposes a ClusterIP service. To access it from your local machine, use port-forward:


```sh
kubectl port-forward svc/ui 30080:80
Forwarding from 127.0.0.1:30080 -> 8080
Forwarding from [::1]:30080 -> 8080
```

> Tip: If the service name isn’t exactly ui, find it via label:

```sh
kubectl get svc -l app.kubernetes.io/instance=ui
NAME   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
ui     ClusterIP   172.20.134.97   <none>        80/TCP    9m
```

http://localhost:30080/

http://localhost:30080/topology

## Upgrade Retail UI Release


```SH
# Upgrade to a new chart version (1.2.4) and change app theme (example)
helm upgrade ui oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.6.1 \
  --set app.theme=orange
# ----------------------------------------------------------------------------------------------------------------------------------------
# Check release history
helm history ui
# ----------------------------------------------------------------------------------------------------------------------------------------
# Watch Pods during rollout
kubectl get pods -w
# ----------------------------------------------------------------------------------------------------------------------------------------
# (If service is ClusterIP) Port-forward again to access the app
kubectl port-forward svc/ui 30080:80
# Then browse:
# http://localhost:30080
```

> Outputs

```sh
helm upgrade ui oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.2.4 \
  --set app.theme=orange
Pulled: public.ecr.aws/aws-containers/retail-store-sample-ui-chart:1.6.1
Digest: sha256:efa886f13f1157735a085b338b7d1fd764614d338f53d5454b4cc765411ab933
Release "ui" has been upgraded. Happy Helming!
NAME: ui
LAST DEPLOYED: Fri Jun 19 18:47:56 2026
NAMESPACE: default
STATUS: deployed
REVISION: 2
DESCRIPTION: Upgrade complete
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=ui,app.kubernetes.io/instance=ui" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace default port-forward $POD_NAME 8080:80

# ----------------------------------------------------------------------------------------------------------------------------------------

helm history ui
REVISION        UPDATED                         STATUS          CHART                                   APP VERSION     DESCRIPTION
1               Fri Jun 19 18:35:34 2026        superseded      retail-store-sample-ui-chart-1.6.1                      Install complete
2               Fri Jun 19 18:47:56 2026        deployed        retail-store-sample-ui-chart-1.6.1                      Upgrade complete

# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl get pods -w
NAME                  READY   STATUS              RESTARTS   AGE
ui-7f7df55448-plrzn   0/1     ContainerCreating   0          4s
ui-7f7df55448-plrzn   0/1     Running             0          59s
ui-7f7df55448-plrzn   1/1     Running             0          81s

# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl get pods,deploy
NAME                      READY   STATUS    RESTARTS   AGE
pod/ui-7f7df55448-plrzn   1/1     Running   0          4m31s

NAME                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/ui   1/1     1            1           23m
```

## Print Helm Values & Manifests

```sh
# Print only overridden values
helm get values ui
# ----------------------------------------------------------------------------------------------------------------------------------------
# Print all values (defaults + overrides)
helm get values ui --all
# ----------------------------------------------------------------------------------------------------------------------------------------
# Print rendered Kubernetes manifests (Deployment, Service, etc.)
helm get manifest ui
```

> Outputs

```sh
helm get values ui
USER-SUPPLIED VALUES:
app:
  theme: orange

# ----------------------------------------------------------------------------------------------------------------------------------------

helm get values ui --all
COMPUTED VALUES:
affinity: {}
app:
  chat:
    bedrock:
      region: ""
    enabled: false
    model: ""
    openai:
      baseUrl: ""
    provider: ""
  endpoints: {}
  theme: orange
autoscaling:
  enabled: false
  maxReplicas: 10
  minReplicas: 1
  targetCPUUtilizationPercentage: 50
configMap:
  create: true
  name: null
fullnameOverride: ""
image:
  pullPolicy: IfNotPresent
  repository: public.ecr.aws/aws-containers/retail-store-sample-ui
  tag: null
imagePullSecrets: []
ingress:
  annotations: {}
  enabled: false
  hosts: []
  tls: []
ingresses: []
istio:
  enabled: false
  hosts: []
metrics:
  enabled: true
  podAnnotations:
    prometheus.io/path: /actuator/prometheus
    prometheus.io/port: "8080"
    prometheus.io/scrape: "true"
nameOverride: ""
nodeSelector: {}
opentelemetry:
  enabled: false
  instrumentation: ""
podAnnotations: {}
podDisruptionBudget:
  enabled: false
  maxUnavailable: 1
  minAvailable: 2
podSecurityContext:
  fsGroup: 1000
replicaCount: 1
resources:
  limits:
    memory: 512Mi
  requests:
    cpu: 128m
    memory: 512Mi
securityContext:
  capabilities:
    add:
    - NET_BIND_SERVICE
    drop:
    - ALL
  readOnlyRootFilesystem: true
  runAsNonRoot: true
  runAsUser: 1000
service:
  port: 80
  type: ClusterIP
serviceAccount:
  annotations: {}
  create: true
  name: ""
tolerations: []
topologySpreadConstraints: []

# ----------------------------------------------------------------------------------------------------------------------------------------

helm get values ui --all
COMPUTED VALUES:
affinity: {}
app:
  chat:
    bedrock:
      region: ""
    enabled: false
    model: ""
    openai:
      baseUrl: ""
    provider: ""
  endpoints: {}
  theme: orange
autoscaling:
  enabled: false
  maxReplicas: 10
  minReplicas: 1
  targetCPUUtilizationPercentage: 50
configMap:
  create: true
  name: null
fullnameOverride: ""
image:
  pullPolicy: IfNotPresent
  repository: public.ecr.aws/aws-containers/retail-store-sample-ui
  tag: null
imagePullSecrets: []
ingress:
  annotations: {}
  enabled: false
  hosts: []
  tls: []
ingresses: []
istio:
  enabled: false
  hosts: []
metrics:
  enabled: true
  podAnnotations:
    prometheus.io/path: /actuator/prometheus
    prometheus.io/port: "8080"
    prometheus.io/scrape: "true"
nameOverride: ""
nodeSelector: {}
opentelemetry:
  enabled: false
  instrumentation: ""
podAnnotations: {}
podDisruptionBudget:
  enabled: false
  maxUnavailable: 1
  minAvailable: 2
podSecurityContext:
  fsGroup: 1000
replicaCount: 1
resources:
  limits:
    memory: 512Mi
  requests:
    cpu: 128m
    memory: 512Mi
securityContext:
  capabilities:
    add:
    - NET_BIND_SERVICE
    drop:
    - ALL
  readOnlyRootFilesystem: true
  runAsNonRoot: true
  runAsUser: 1000
service:
  port: 80
  type: ClusterIP
serviceAccount:
  annotations: {}
  create: true
  name: ""
tolerations: []
topologySpreadConstraints: []

tchat@247-Tchatua MINGW64 ~/OneDrive/Documents/2026/a09_Platform_Engineer/a04_Udemy/a13_Ultimate_DevOps_Real_World_Project_on_AWS_Cloud/drwp_aws_eks (develop)
$ helm get manifest ui
---
# Source: retail-store-sample-ui-chart/templates/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ui
  labels:
    helm.sh/chart: ui-1.2.4
    app.kubernetes.io/name: ui
    app.kubernetes.io/instance: ui
    app.kubernetes.io/component: service
    app.kubernetes.io/owner: retail-store-sample
    app.kubernetes.io/managed-by: Helm
---
# Source: retail-store-sample-ui-chart/templates/configmap.yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: ui
data:
  RETAIL_UI_THEME: orange
---
# Source: retail-store-sample-ui-chart/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: ui
  labels:
    helm.sh/chart: ui-1.2.4
    app.kubernetes.io/name: ui
    app.kubernetes.io/instance: ui
    app.kubernetes.io/component: service
    app.kubernetes.io/owner: retail-store-sample
    app.kubernetes.io/managed-by: Helm
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: ui
    app.kubernetes.io/instance: ui
    app.kubernetes.io/component: service
    app.kubernetes.io/owner: retail-store-sample
---
# Source: retail-store-sample-ui-chart/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ui
  labels:
    helm.sh/chart: ui-1.2.4
    app.kubernetes.io/name: ui
    app.kubernetes.io/instance: ui
    app.kubernetes.io/component: service
    app.kubernetes.io/owner: retail-store-sample
    app.kubernetes.io/managed-by: Helm
spec:
  replicas: 1
  strategy:
    rollingUpdate:
      maxUnavailable: 1
    type: RollingUpdate
  selector:
    matchLabels:
      app.kubernetes.io/name: ui
      app.kubernetes.io/instance: ui
      app.kubernetes.io/component: service
      app.kubernetes.io/owner: retail-store-sample
  template:
    metadata:
      annotations:
        prometheus.io/path: /actuator/prometheus
        prometheus.io/port: "8080"
        prometheus.io/scrape: "true"
      labels:
        app.kubernetes.io/name: ui
        app.kubernetes.io/instance: ui
        app.kubernetes.io/component: service
        app.kubernetes.io/owner: retail-store-sample
    spec:
      serviceAccountName: ui
      securityContext:
        fsGroup: 1000
      containers:
        - name: ui
          env:
            - name: JAVA_OPTS
              value: -XX:MaxRAMPercentage=75.0 -Djava.security.egd=file:/dev/urandom
            - name: METADATA_KUBERNETES_POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: METADATA_KUBERNETES_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
            - name: METADATA_KUBERNETES_NODE_NAME
              valueFrom:
                fieldRef:
                  fieldPath: spec.nodeName
          envFrom:
            - configMapRef:
                name: ui
          securityContext:
            capabilities:
              add:
              - NET_BIND_SERVICE
              drop:
              - ALL
            readOnlyRootFilesystem: true
            runAsNonRoot: true
            runAsUser: 1000
          image: "public.ecr.aws/aws-containers/retail-store-sample-ui:1.2.4"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 8080
              protocol: TCP
          readinessProbe:
            httpGet:
              path: /actuator/health/readiness
              port: 8080
            initialDelaySeconds: 10
          resources:
            limits:
              memory: 512Mi
            requests:
              cpu: 128m
              memory: 512Mi
          volumeMounts:
            - mountPath: /tmp
              name: tmp-volume
      volumes:
        - name: tmp-volume
          emptyDir:
            medium: Memory
```

## Rollback to Previous Release

```sh
# Show release history
helm history ui
# ----------------------------------------------------------------------------------------------------------------------------------------
# Roll back to revision 1
helm rollback ui 1
# ----------------------------------------------------------------------------------------------------------------------------------------
# Verify rollback
helm list
helm history ui
kubectl get pods -w
# ----------------------------------------------------------------------------------------------------------------------------------------
# (If service is ClusterIP) Port-forward to access the application
kubectl port-forward svc/ui 30080:80
# http://localhost:30080
```

> Outputs

```sh
helm history ui
REVISION        UPDATED                         STATUS          CHART                                   APP VERSION    DESCRIPTION
1               Fri Jun 19 18:35:34 2026        superseded      retail-store-sample-ui-chart-1.6.1  Install complete
2               Fri Jun 19 18:47:56 2026        superseded      retail-store-sample-ui-chart-1.6.1  Upgrade complete
3               Fri Jun 19 18:54:50 2026        deployed        retail-store-sample-ui-chart-1.2.4  Upgrade complete

# ----------------------------------------------------------------------------------------------------------------------------------------

helm rollback ui 2
Rollback was a success! Happy Helming!
```

- Pro Tips
  - helm rollback ui → rolls back to the last successful release.
  - helm rollback ui 1 --dry-run → preview rollback without applying.

## Update Application Theme

I can update application values (like theme) during an upgrade.

👉 Pods may not restart automatically because ConfigMap/env changes don’t always trigger a rollout. If that happens, restart the Deployment manually.

```sh
# First Upgrade to latest version
helm upgrade ui oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.3.0
# ----------------------------------------------------------------------------------------------------------------------------------------
# Change theme to green (stays on chart version 1.3.0)
helm upgrade ui oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.6.1 \
  --set app.theme=green
# ----------------------------------------------------------------------------------------------------------------------------------------
# If pods don't restart automatically, trigger a rollout:
kubectl rollout restart deployment/ui
# ----------------------------------------------------------------------------------------------------------------------------------------
# Verify pods
kubectl get pods
# ----------------------------------------------------------------------------------------------------------------------------------------
# (If service is ClusterIP) Port-forward to access the app
kubectl port-forward svc/ui 30080:80
# http://localhost:30080
```sh

> Outputs

```sh
kubectl get deploy
NAME   READY   UP-TO-DATE   AVAILABLE   AGE
ui     1/1     1            1           59m

# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl rollout restart deploy/ui
deployment.apps/ui restarted
```

## Uninstall Retail UI Release

```sh
kubectl get pod,deploy,sa,cm,sts
NAME                      READY   STATUS    RESTARTS   AGE
pod/ui-65dfbc9bd7-8j9tt   1/1     Running   0          3m35s

NAME                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/ui   1/1     1            1           63m

NAME                     SECRETS   AGE
serviceaccount/default   0         95m
serviceaccount/ui        0         63m

NAME                         DATA   AGE
configmap/kube-root-ca.crt   1      95m
configmap/ui                 2      63m

# ----------------------------------------------------------------------------------------------------------------------------------------

helm list
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                                   APP VERSION
ui      default         9               2026-06-19 19:33:18.0711889 -0400 EDT   deployed        retail-store-sample-ui-chart-1.6.1

# ----------------------------------------------------------------------------------------------------------------------------------------

helm uninstall ui
release "ui" uninstalled
```


