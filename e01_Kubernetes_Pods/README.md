# Kubernetes Pods

Pod is a single instance of my application

```sh
aws eks --region us-east-2 update-kubeconfig --name south-jersey-eks-tchatua-dev-eks-control-plane
Updated context arn:aws:eks:us-east-2:088354478627:cluster/south-jersey-eks-tchatua-dev-eks-control-plane in C:\Users\tchat\.kube\config
```

## How Do We Run a Pod in Kubernetes?

To understand Pods, I first need to recall how things work in Docker.

- **Docker Side**
    - In Docker, I have:
        - A Docker image
        - I run `docker run`
        - Docker creates a container
        - That container is a single running instance of my application
    - If I want multiple container instances, I simply run multiple containers.

- **Kubernetes Side**

    - I cannot run containers directly in Kubernetes. Kubernetes does not manage containers individually.

    - *Kubernetes manages Pods — a higher level abstraction*

## What Is a Kubernetes Pod?

- A **Pod** is the smallest deployable unit in Kubernetes. Think of it as a wrapper around one or more containers.

- Inside a Pod, I have:
    - My container
    - A dedicated network namespace
    - Optional storage volumes
    - Pod level identity and metadata

- Kubernetes never runs my container directly. It always creates a Pod, and the Pod runs my container inside it.

## Where Do Pods Actually Run?

- **Pods** run on worker nodes.

- Imagine I have two worker nodes:
    - Worker Node 1
    - Worker Node 2
    - The **Kubernetes Scheduler** decides where each Pod should run based on available CPU, memory, and other constraints.
        - Example:
            - Pod 1 → Node 1
            - Pod 2 → Node 1
            - If Node 1 is full → Pod 3 → Node 2
            - Kubernetes automatically spreads Pods across nodes. I don’t manually choose where they go — Kubernetes handles it.

## Scaling in Kubernetes

- If my catalog service starts receiving heavy traffic, what do I do?
    - I simply create more Pods.
    - Each Pod runs one identical instance of my application container.

    - In Docker:        Container = one instance
    - In Kubernetes:    Pod = one instance
    - *One Container per Pod is The Best Practice*

    - Although a Pod can technically run multiple containers, the recommended approach is:
        - One Pod = One Container = One instance of my application

        - **Example of the correct approach:**
            - Pod A → CTM container
            - Pod B → CTM container

        - **Incorrect approach:**
            - Pod → CTM container 1 + CTM container 2 (Not recommended)
            - If I need another instance, I have to create another Pod. Not another container inside the same Pod.

## So Why Do Multi Container Pods Exist?

- Great question.

- Multi container Pods are used for sidecar or helper containers.

- **Example use cases:**
    - A logging agent that ships logs to CloudWatch
    - An Envoy proxy for service mesh (Istio)
    - A data puller or metrics collector
    - In these cases:
        - The main container runs my application
        - The sidecar container performs supporting tasks
        - They share the same network and storage
        - This is the sidecar pattern, not multiple instances of the same app.

## As Summary:

- Kubernetes never runs containers directly
- Kubernetes always runs Pods
- A Pod is the smallest deployable unit on Kubernetes
- A Pod usually contains one main container
- Pods run on worker nodes
- Kubernetes automatically schedules Pods across nodes
- **Scaling = adding more Pods**
- Multi container Pods are for sidecars, not multiple app instances

```sh
# ----------------------------------------------------------------------------------------------------------------------------------------
aws eks --region us-east-2 update-kubeconfig --name south-jersey-eks-tchatua-dev-eks-control-plane
Updated context arn:aws:eks:us-east-2:088354478627:cluster/south-jersey-eks-tchatua-dev-eks-control-plane in C:\Users\tchat\.kube\config

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get nodes
NAME                                           STATUS   ROLES    AGE    VERSION
ip-192-168-10-21.us-east-2.compute.internal    Ready    <none>   4h6m   v1.34.8-eks-3385e9b
ip-192-168-11-24.us-east-2.compute.internal    Ready    <none>   4h6m   v1.34.8-eks-3385e9b
ip-192-168-12-172.us-east-2.compute.internal   Ready    <none>   4h6m   v1.34.8-eks-3385e9b

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl apply -f a01_Pod_Manifest_File.yml
pod/catalog-pod created

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get pod
NAME          READY   STATUS    RESTARTS   AGE
catalog-pod   1/1     Running   0          43s

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl describe pod catalog-pod
Name:             catalog-pod
Namespace:        default
Priority:         0
Service Account:  default
Node:             ip-192-168-12-172.us-east-2.compute.internal/192.168.12.172
Start Time:       Mon, 08 Jun 2026 13:55:11 -0400
Labels:           app=catalog
Annotations:      <none>
Status:           Running
IP:               192.168.12.249
IPs:
  IP:  192.168.12.249
Containers:
  catalog:
    Container ID:   containerd://21b0305fb5a11941aa359e346c7f3ef41420edfea3a09bfa9a01bb32e2f2cdc9
    Image:          public.ecr.aws/aws-containers/retail-store-sample-catalog:1.3.0
    Image ID:       public.ecr.aws/aws-containers/retail-store-sample-catalog@sha256:b654b266fa32d01aa794274388dc2775563b3a993b6ea17ee33460ca484d8f3f
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 08 Jun 2026 13:55:17 -0400
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:     200m
      memory:  256Mi
    Requests:
      cpu:        100m
      memory:     128Mi
    Readiness:    http-get http://:8080/health delay=0s timeout=1s period=10s #success=1 #failure=3
    Environment:  <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-rjmkz (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True
  Initialized                 True
  Ready                       True
  ContainersReady             True
  PodScheduled                True
Volumes:
  kube-api-access-rjmkz:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   Burstable
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  106s  default-scheduler  Successfully assigned default/catalog-pod to ip-192-168-12-172.us-east-2.compute.internal
  Normal  Pulling    106s  kubelet            Pulling image "public.ecr.aws/aws-containers/retail-store-sample-catalog:1.3.0"
  Normal  Pulled     100s  kubelet            Successfully pulled image "public.ecr.aws/aws-containers/retail-store-sample-catalog:1.3.0" in 5.979s (5.979s including waiting). Image size: 75515764 bytes.
  Normal  Created    100s  kubelet            Created container: catalog
  Normal  Started    99s   kubelet            Started container catalog

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get pods
NAME          READY   STATUS    RESTARTS   AGE
catalog-pod   1/1     Running   0          10m

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl logs -f catalog-pod
Using in-memory database
Running database migration...
Database migration complete

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl port-forward pod/catalog-pod 7080:8080
Forwarding from 127.0.0.1:7080 -> 8080
Forwarding from [::1]:7080 -> 8080
Handling connection for 7080
Handling connection for 7080
# ----------------------------------------------------------------------------------------------------------------------------------------

http://localhost:7080/health
http://localhost:7080/topology
http://localhost:7080/catalog/products
# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl logs -f catalog-pod
Using in-memory database
Running database migration...
Database migration complete
[GIN] 2026/06/08 - 19:39:16 | 404 |      87.066µs |       127.0.0.1 | GET      "/"
[GIN] 2026/06/08 - 19:39:16 | 404 |      21.736µs |       127.0.0.1 | GET      "/favicon.ico"
[GIN] 2026/06/08 - 19:41:19 | 200 |      46.321µs |       127.0.0.1 | GET      "/topology"
[GIN] 2026/06/08 - 19:42:09 | 404 |      21.471µs |       127.0.0.1 | GET      "/catalog/product"
[GIN] 2026/06/08 - 19:42:17 | 200 |    1.020706ms |       127.0.0.1 | GET      "/catalog/products"

# ----------------------------------------------------------------------------------------------------------------------------------------

http://localhost:7080/catalog/products/a1258cd2-176c-4507-ade6-746dab5ad625
http://localhost:7080/catalog/size
http://localhost:7080/catalog/tags
```

```sh
kubectl exec -it catalog-pod -- sh
sh-5.2$ id
uid=1000(appuser) gid=1000(appuser) groups=1000(appuser)
sh-5.2$

# ----------------------------------------------------------------------------------------------------------------------------------------
 kubectl exec -it catalog-pod -- ls
LICENSES.md  main

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl exec -it catalog-pod -- env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=catalog-pod
APPUSER=appuser
APPUID=1000
APPGID=1000
GIN_MODE=release
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_ADDR=172.20.0.1
KUBERNETES_SERVICE_HOST=172.20.0.1
KUBERNETES_SERVICE_PORT=443
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT=tcp://172.20.0.1:443
KUBERNETES_PORT_443_TCP=tcp://172.20.0.1:443
TERM=xterm
HOME=/app
```

- To delete Pod

```sh
# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl get pod
NAME          READY   STATUS    RESTARTS   AGE
catalog-pod   1/1     Running   0          124m
# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl delete pod catalog-pod
pod "catalog-pod" deleted

```