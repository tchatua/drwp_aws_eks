# Kubernetes ConfigMap

## Create ConfigMap

```yml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: catalog
data:
  CATALOG_PERSISTENCE_PROVIDER: "in-memory"
  CATALOG_PERSISTENCE_ENDPOINT: ""
  CATALOG_PERSISTENCE_DB_NAME: "catalogdb"
  CATALOG_PERSISTENCE_USER: "catalog_user"
  CATALOG_PERSISTENCE_PASSWORD: ""
  CATALOG_PERSISTENCE_CONNECT_TIMEOUT: "5"
```

## Update Deployment to use ConfigMap

Under the container section, add:

```yml
containers:
  - name: catalog
    envFrom:
      - configMapRef:
          name: catalog
```

This tells Kubernetes to load all key-value pairs from the ConfigMap as environment variables inside the container.

## Deployment and verifications

```sh
kubectl apply -f e04_Kubernetes_ConfigMap/
deployment.apps/catalog created
service/catalog-service created
configmap/catalog-config created

# -----------------------------------------------------------------------------------------------------------------------------
kubectl get pods
NAME                       READY   STATUS    RESTARTS   AGE
catalog-85f8d84bf7-c8qzz   1/1     Running   0          41s
catalog-85f8d84bf7-k5bwc   1/1     Running   0          41s
catalog-85f8d84bf7-qq5jr   1/1     Running   0          41s

# -----------------------------------------------------------------------------------------------------------------------------
kubectl get cm
NAME               DATA   AGE
catalog-config     6      69s
kube-root-ca.crt   1      5h55m

# -----------------------------------------------------------------------------------------------------------------------------
kubectl describe cm catalog-config
Name:         catalog-config
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
CATALOG_PERSISTENCE_CONNECT_TIMEOUT:
----
5

CATALOG_PERSISTENCE_DB_NAME:
----
catalogdb

CATALOG_PERSISTENCE_ENDPOINT:
----


CATALOG_PERSISTENCE_PASSWORD:
----


CATALOG_PERSISTENCE_PROVIDER:
----
in-memory

CATALOG_PERSISTENCE_USER:
----
cataloguser


BinaryData
====

Events:  <none>


# -----------------------------------------------------------------------------------------------------------------------------
 kubectl get pods
NAME                       READY   STATUS    RESTARTS   AGE
catalog-85f8d84bf7-c8qzz   1/1     Running   0          5m37s
catalog-85f8d84bf7-k5bwc   1/1     Running   0          5m37s
catalog-85f8d84bf7-qq5jr   1/1     Running   0          5m37s

# -----------------------------------------------------------------------------------------------------------------------------
kubectl exec -it catalog-85f8d84bf7-qq5jr -- env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=catalog-85f8d84bf7-qq5jr
APPUSER=appuser
APPUID=1000
APPGID=1000
GIN_MODE=release
CATALOG_PERSISTENCE_USER=cataloguser
CATALOG_PERSISTENCE_CONNECT_TIMEOUT=5
CATALOG_PERSISTENCE_DB_NAME=catalogdb
CATALOG_PERSISTENCE_ENDPOINT=
CATALOG_PERSISTENCE_PASSWORD=
CATALOG_PERSISTENCE_PROVIDER=in-memory
CATALOG_SERVICE_PORT_8080_TCP_PORT=8080
CATALOG_SERVICE_PORT_8080_TCP_ADDR=172.20.167.90
KUBERNETES_SERVICE_HOST=172.20.0.1
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT=tcp://172.20.0.1:443
KUBERNETES_PORT_443_TCP=tcp://172.20.0.1:443
CATALOG_SERVICE_SERVICE_HOST=172.20.167.90
CATALOG_SERVICE_SERVICE_PORT=8080
CATALOG_SERVICE_PORT=tcp://172.20.167.90:8080
CATALOG_SERVICE_PORT_8080_TCP=tcp://172.20.167.90:8080
KUBERNETES_PORT_443_TCP_ADDR=172.20.0.1
KUBERNETES_SERVICE_PORT=443
KUBERNETES_PORT_443_TCP_PROTO=tcp
CATALOG_SERVICE_SERVICE_PORT_HTTP=8080
CATALOG_SERVICE_PORT_8080_TCP_PROTO=tcp
TERM=xterm
HOME=/app

# -----------------------------------------------------------------------------------------------------------------------------
kubectl exec -it catalog-85f8d84bf7-qq5jr -- env | grep PERSISTENCE
CATALOG_PERSISTENCE_USER=cataloguser
CATALOG_PERSISTENCE_CONNECT_TIMEOUT=5
CATALOG_PERSISTENCE_DB_NAME=catalogdb
CATALOG_PERSISTENCE_ENDPOINT=
CATALOG_PERSISTENCE_PASSWORD=
CATALOG_PERSISTENCE_PROVIDER=in-memory

# -----------------------------------------------------------------------------------------------------------------------------
kubectl delete -f e04_Kubernetes_ConfigMap/
deployment.apps "catalog" deleted
service "catalog-service" deleted
configmap "catalog-config" deleted

# -----------------------------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------------------------

```