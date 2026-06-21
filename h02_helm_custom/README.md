# Helm Custom Values - Retail Store UI with Ingress (HTTP)

In this lab, I expose my Helm knowledge by deploying the Retail Store UI with a custom values-ui.yaml file.

- Enable Ingress with AWS Load Balancer Controller (ALB)
- Set App theme to green

## Helm Values 

### Where do values come from?

- Chart defaults: `values.yaml` inside the chart (what the author ships)
- My overrides: `-f <file.yaml>` (recommended) and/or `--set key=value` (quick tweaks)

### Precedence (highest → lowest):

1. `--set` (and `--set-string`)
2. Multiple `-f` files in order (the last file wins for the same key)
3. Chart’s default `values.yaml`

### Best practices:

- Prefer `-f values-<env>.yaml` for most overrides; use `--set` for small, one-off changes.
- Keep environment files (`values-dev.yaml`, `values-stg.yaml`, `values-prod.yaml`) to avoid accidental drift.
- Avoid putting secrets in values files. Use External Secrets or **Kubernetes Secrets + IRSA (IAM Roles for Service Accounts)**.

## Inspect & preview:

```sh
# See chart default values (great for discovering knobs)
helm show values oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart --version 1.3.0

# Dry-run to preview what will be applied
helm install ui oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart --version 1.3.0 -f values_ui.yml --dry-run --debug | less
```

> Outputs

```sh
helm show values oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart --version 1.3.0
Pulled: public.ecr.aws/aws-containers/retail-store-sample-ui-chart:1.3.0
Digest: sha256:67d6422cb2a52bb0955022ef60cab027031d631c85807418b24f90ae03e2f0a4
# Default values for ui.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

replicaCount: 1

image:
  repository: public.ecr.aws/aws-containers/retail-store-sample-ui
  pullPolicy: IfNotPresent
  tag:

imagePullSecrets: []
nameOverride: ""
fullnameOverride: ""

serviceAccount:
  # Specifies whether a service account should be created
  create: true
  # Annotations to add to the service account
  annotations: {}
  # The name of the service account to use.
  # If not set and create is true, a name is generated using the fullname template
  name: ""

podAnnotations: {}

podSecurityContext:
  fsGroup: 1000

securityContext:
  capabilities:
    drop:
      - ALL
    add:
      - NET_BIND_SERVICE
  readOnlyRootFilesystem: true
  runAsNonRoot: true
  runAsUser: 1000

service:
  type: ClusterIP
  port: 80
  # annotations: {}
  # loadBalancerClass: ""
  # nodePort: 30000

resources:
  limits:
    memory: 512Mi
  requests:
    cpu: 128m
    memory: 512Mi

autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 10
  targetCPUUtilizationPercentage: 50

nodeSelector: {}

tolerations: []

affinity: {}

topologySpreadConstraints: []

metrics:
  enabled: true
  podAnnotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8080"
    prometheus.io/path: "/actuator/prometheus"

configMap:
  create: true
  name: # if blank this will be generated

app:
  # theme: default
  endpoints: {}
    #catalog: http://catalog:80
    #carts: http://carts:80
    #orders: http://orders:80
    #checkout: http://checkout:80
  chat:
    enabled: false
    provider: ""
    model: ""
    # temperature: 0.7
    # maxTokens: 300
    # prompt: |
    #   This will override the default system prompt
    bedrock:
      region: ""
    openai:
      baseUrl: ""
      # apiKey: ""

## Ingress for load balancer
ingress:
  enabled: false
  # className: ""
  annotations: {}
  #   alb.ingress.kubernetes.io/scheme: internet-facing
  #   alb.ingress.kubernetes.io/target-type: ip
  #   alb.ingress.kubernetes.io/healthcheck-path: /actuator/health/liveness
  tls: []
  #  - secretName: chart-example-tls
  #    hosts:
  #      - chart-example.local
  hosts: []
  #  - "chart-example.local"

ingresses: []
  # - name: default
  #   className: ""
  #   hosts: []
  #   annotations: {}
  #   tls: []

ingresses:
  []
  # - name: default
  #   className: ""
  #   hosts: []
  #   annotations: {}
  #   tls: []

istio:
  enabled: false
  hosts: []

opentelemetry:
  enabled: false
  instrumentation: ""

podDisruptionBudget:
  enabled: false
  minAvailable: 2
  maxUnavailable: 1
```


```sh
helm install ui oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart --version 1.3.0 -f values_ui.yml --dry-run --debug | less
NAME: ui
LAST DEPLOYED: Fri Jun 19 20:56:53 2026
NAMESPACE: default
STATUS: pending-install
REVISION: 1
DESCRIPTION: Dry run complete
USER-SUPPLIED VALUES:
app:
  theme: teal
ingress:
  annotations:
    alb.ingress.kubernetes.io/healthcheck-path: /actuator/health/liveness
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
  className: alb
  enabled: true
  hosts: []
  tls: []

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
...
LAST DEPLOYED: Fri Jun 19 20:54:05 2026
NAMESPACE: default
STATUS: pending-install
REVISION: 1
DESCRIPTION: Dry run complete
USER-SUPPLIED VALUES:

app:
  theme: teal
ingress:
  annotations:
    alb.ingress.kubernetes.io/healthcheck-path: /actuator/health/liveness
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
  className: alb
  enabled: true
  hosts: []
  tls: []

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
  theme: teal
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
:
```

## Upgrades & reuse:

- `helm upgrade ui ... -f values-ui.yaml` applies changes from my file.
- `--reuse-values` merges prior overrides with new ones (handy, but can carry stale flags—use thoughtfully).

## Kubernetes rollout nuance:

- If a value only changes a ConfigMap/env, pods might not auto‑restart.

    - Use: `kubectl rollout restart deployment/ui` to pick up changes.

## ALB Ingress prerequisites (recap):

- AWS Load Balancer Controller (installed & IAM/IRSA configured)
- Subnets tagged for ALB (usually already done in cluster networking)
- An IngressClass in the cluster (default or explicitly referenced via className)


```sh
kubectl get ingressclass
NAME   CONTROLLER            PARAMETERS   AGE
alb    ingress.k8s.aws/alb   <none>       176m

# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl get deploy -n kube-system aws-load-balancer-controller
NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
aws-load-balancer-controller   2/2     2            2           3h1m

# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl get pods -n kube-system
NAME                                                              READY   STATUS    RESTARTS   AGE
aws-load-balancer-controller-7484b6ff87-qbjr6                     1/1     Running   0          3h2m
aws-load-balancer-controller-7484b6ff87-vlnxw                     1/1     Running   0          3h2m
aws-node-s2q24                                                    2/2     Running   0          3h3m
aws-node-xn8n7                                                    2/2     Running   0          3h3m
coredns-64ff95db9-c24tf                                           1/1     Running   0          3h5m
coredns-64ff95db9-gxpcx                                           1/1     Running   0          3h5m
csi-secrets-store-secrets-store-csi-driver-4bzlg                  3/3     Running   0          3h2m
csi-secrets-store-secrets-store-csi-driver-n96h4                  3/3     Running   0          3h2m
ebs-csi-controller-76586b6fb-htzdn                                6/6     Running   0          3h2m
ebs-csi-controller-76586b6fb-kmfxq                                6/6     Running   0          3h2m
ebs-csi-node-7dgqm                                                3/3     Running   0          3h2m
ebs-csi-node-dbj7d                                                3/3     Running   0          3h2m
eks-pod-identity-agent-cvpm9                                      1/1     Running   0          3h3m
eks-pod-identity-agent-gr7bt                                      1/1     Running   0          3h3m
kube-proxy-59p9j                                                  1/1     Running   0          3h3m
kube-proxy-h5db7                                                  1/1     Running   0          3h3m
secrets-provider-aws-secrets-store-csi-driver-provider-aws5qfxn   1/1     Running   0          3h2m
secrets-provider-aws-secrets-store-csi-driver-provider-awsqg8wr   1/1     Running   0          3h2m
```

## Install Helm Release with Custom Values (Recap)

```sh
# Verify if AWS Load Balancer Controller installed
kubectl get deploy  -n kube-system aws-load-balancer-controller
kubectl get pods -n kube-system
# ----------------------------------------------------------------------------------------------------------------------------------------
# Verify Default Ingressclass configured
kubectl get ingressclass
Observation: "alb" should be default ingressclass
# ----------------------------------------------------------------------------------------------------------------------------------------
# Helm Install
helm install ui oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.3.0 \
  -f values_ui.yml
```

> OUtputs

```sh
helm list
NAME    NAMESPACE       REVISION        UPDATED STATUS  CHART   APP VERSION

# ----------------------------------------------------------------------------------------------------------------------------------------

helm install ui oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.3.0 \
  -f values_ui.yml
Pulled: public.ecr.aws/aws-containers/retail-store-sample-ui-chart:1.3.0
Digest: sha256:67d6422cb2a52bb0955022ef60cab027031d631c85807418b24f90ae03e2f0a4
NAME: ui
LAST DEPLOYED: Fri Jun 19 21:25:18 2026
NAMESPACE: default
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=ui,app.kubernetes.io/instance=ui" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace default port-forward $POD_NAME 8080:80
```

## Verify Ingress and ALB

```sh
# List Helm Release
helm list

# This gives a nice summary of resources created by the release.
helm status ui --show-resources

# After install/upgrade, see effective values
helm get values ui --all

# Shows all Kubernetes manifests (raw YAML) rendered and applied by Helm:
helm get manifest ui


# Pods created by the release
kubectl get pods

# Services (expect ClusterIP for internal communication)
kubectl get svc

# Ingress (ALB will be created by the controller)
kubectl get ingress

# Describe the Ingress to view ALB details and events
kubectl describe ingress ui
```

## Outputs

```sh
# ----------------------------------------------------------------------------------------------------------------------------------------
helm list
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
ui      default         1               2026-06-19 21:25:18.3430559 -0400 EDT   deployed        retail-store-sample-ui-chart-1.3.0

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
  theme: teal
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
  annotations:
    alb.ingress.kubernetes.io/healthcheck-path: /actuator/health/liveness
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
  className: alb
  enabled: true
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

helm get manifest ui
---
# Source: retail-store-sample-ui-chart/templates/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ui
  labels:
    helm.sh/chart: ui-1.3.0
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
  RETAIL_UI_THEME: teal
---
# Source: retail-store-sample-ui-chart/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: ui
  labels:
    helm.sh/chart: ui-1.3.0
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
    helm.sh/chart: ui-1.3.0
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
          image: "public.ecr.aws/aws-containers/retail-store-sample-ui:1.3.0"
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
---
# Source: retail-store-sample-ui-chart/templates/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ui
  labels:
    helm.sh/chart: ui-1.3.0
    app.kubernetes.io/name: ui
    app.kubernetes.io/instance: ui
    app.kubernetes.io/component: service
    app.kubernetes.io/owner: retail-store-sample
    app.kubernetes.io/managed-by: Helm
  annotations:
    alb.ingress.kubernetes.io/healthcheck-path: /actuator/health/liveness
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
spec:
  ingressClassName: alb
  rules:
    - http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: ui
                port:
                  number: 80


# ----------------------------------------------------------------------------------------------------------------------------------------

helm status ui
NAME: ui
LAST DEPLOYED: Fri Jun 19 21:25:18 2026
NAMESPACE: default
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
RESOURCES:
==> v1/ConfigMap
NAME   DATA   AGE
ui     1      11m

==> v1/Service
NAME   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
ui     ClusterIP   172.20.145.158   <none>        80/TCP    11m

==> v1/Deployment
NAME   READY   UP-TO-DATE   AVAILABLE   AGE
ui     1/1     1            1           11m

==> v1/Pod(related)
NAME                  READY   STATUS    RESTARTS   AGE
ui-7d45fc58bf-xfbcg   1/1     Running   0          11m

==> v1/Ingress
NAME   CLASS   HOSTS   ADDRESS   PORTS   AGE
ui     alb     *                 80      11m

==> v1/ServiceAccount
NAME   SECRETS   AGE
ui     0         11m


NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=ui,app.kubernetes.io/instance=ui" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace default port-forward $POD_NAME 8080:80


# ----------------------------------------------------------------------------------------------------------------------------------------
# Troubleshooting CLI
aws ec2 create-tags \
  --resources subnet-0e6e4ea695d42f6c6 subnet-005a013bbc07741d0 subnet-07f36d4512999d9d4 \
  --tags Key=kubernetes.io/role/elb,Value=1 \
         Key=kubernetes.io/cluster/south-jersey-eks-tchatua-dev-eks-control-plane,Value=shared
# ----------------------------------------------------------------------------------------------------------------------------------------
helm list
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART
                        APP VERSION
ui      default         1               2026-06-19 21:25:18.3430559 -0400 EDT   deployed        retail-store-sample-ui-chart-1.3.0
# ----------------------------------------------------------------------------------------------------------------------------------------
helm uninstall ui
release "ui" uninstalled

# ----------------------------------------------------------------------------------------------------------------------------------------
ll
total 28
-rw-r--r-- 1 tchat 197609 21112 Jun 19 21:42 README.md
-rw-r--r-- 1 tchat 197609   388 Jun 19 20:47 values_ui.yml

# ----------------------------------------------------------------------------------------------------------------------------------------
helm install ui oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.3.0 \
  -f values_ui.yml

# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl get ingress
NAME   CLASS   HOSTS   ADDRESS                                                            PORTS   AGE
ui     alb     *       k8s-default-ui-38a5e1b50a-1524082187.us-east-2.elb.amazonaws.com   80      4m6s
```

## Observation:

- AWS Load Balancer Controller provisions an internet‑facing ALB
- The app is accessible over HTTP (port 80) using the ALB’s DNS name

