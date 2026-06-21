# Kubernetes Deployment


```sh
# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl apply -f a01_Catalog_Deployment.yml
deployment.apps/catalog created

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get deployment
NAME      READY   UP-TO-DATE   AVAILABLE   AGE
catalog   3/3     3            3           50s

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
catalog-78d7fd7f6-wq97z   1/1     Running   0          76s
catalog-78d7fd7f6-x25bl   1/1     Running   0          76s
catalog-78d7fd7f6-xq68m   1/1     Running   0          76s
```

> To watches the progress of a Deployment rollout and tells me when Kubernetes has successfully updated all Pods to the desired state.

```sh
# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl rollout status deployment/catalog
deployment "catalog" successfully rolled out

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl describe pod catalog-78d7fd7f6-wq97z
Name:             catalog-78d7fd7f6-wq97z
Namespace:        default
Priority:         0
Service Account:  default
Node:             ip-192-168-12-45.us-east-2.compute.internal/192.168.12.45
Start Time:       Tue, 09 Jun 2026 15:25:27 -0400
Labels:           app.kubernetes.io/name=catalog
                  pod-template-hash=78d7fd7f6
Annotations:      <none>
Status:           Running
IP:               192.168.12.76
IPs:
  IP:           192.168.12.76
Controlled By:  ReplicaSet/catalog-78d7fd7f6
Containers:
  catalog:
    Container ID:   containerd://cb3c5a78aac05e6ee84ae8ea1b8633d3146c4b0ad01ee707e3192f213bbe7e97
    Image:          public.ecr.aws/aws-containers/retail-store-sample-catalog:1.0.0
    Image ID:       public.ecr.aws/aws-containers/retail-store-sample-catalog@sha256:b405786f7b0597c81778876d9e4935e7f4cc55d7844ab26b8181f6bfca4ae78a
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Tue, 09 Jun 2026 15:25:31 -0400
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:     200m
      memory:  256Mi
    Requests:
      cpu:        100m
      memory:     256Mi
    Liveness:     http-get http://:8080/health delay=0s timeout=1s period=10s #success=1 #failure=3
    Readiness:    http-get http://:8080/health delay=0s timeout=1s period=10s #success=1 #failure=3
    Environment:  <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-svghq (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True
  Initialized                 True
  Ready                       True
  ContainersReady             True
  PodScheduled                True
Volumes:
  kube-api-access-svghq:
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
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  9m48s  default-scheduler  Successfully assigned default/catalog-78d7fd7f6-wq97z to ip-192-168-12-45.us-east-2.compute.internal
  Normal  Pulling    9m48s  kubelet            Pulling image "public.ecr.aws/aws-containers/retail-store-sample-catalog:1.0.0"
  Normal  Pulled     9m44s  kubelet            Successfully pulled image "public.ecr.aws/aws-containers/retail-store-sample-catalog:1.0.0" in 3.726s (3.726s including waiting). Image size: 73856903 bytes.
  Normal  Created    9m44s  kubelet            Created container: catalog
  Normal  Started    9m44s  kubelet            Started container catalog


# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl describe rs catalog-78d7fd7f6
Name:           catalog-78d7fd7f6
Namespace:      default
Selector:       app.kubernetes.io/name=catalog,pod-template-hash=78d7fd7f6
Labels:         app.kubernetes.io/name=catalog
                pod-template-hash=78d7fd7f6
Annotations:    deployment.kubernetes.io/desired-replicas: 3
                deployment.kubernetes.io/max-replicas: 4
                deployment.kubernetes.io/revision: 1
Controlled By:  Deployment/catalog
Replicas:       3 current / 3 desired
Pods Status:    3 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:  app.kubernetes.io/name=catalog
           pod-template-hash=78d7fd7f6
  Containers:
   catalog:
    Image:      public.ecr.aws/aws-containers/retail-store-sample-catalog:1.0.0
    Port:       8080/TCP
    Host Port:  0/TCP
    Limits:
      cpu:     200m
      memory:  256Mi
    Requests:
      cpu:         100m
      memory:      256Mi
    Liveness:      http-get http://:8080/health delay=0s timeout=1s period=10s #success=1 #failure=3
    Readiness:     http-get http://:8080/health delay=0s timeout=1s period=10s #success=1 #failure=3
    Environment:   <none>
    Mounts:        <none>
  Volumes:         <none>
  Node-Selectors:  <none>
  Tolerations:     <none>
Events:
  Type    Reason            Age   From                   Message
  ----    ------            ----  ----                   -------
  Normal  SuccessfulCreate  17m   replicaset-controller  Created pod: catalog-78d7fd7f6-xq68m
  Normal  SuccessfulCreate  17m   replicaset-controller  Created pod: catalog-78d7fd7f6-x25bl
  Normal  SuccessfulCreate  17m   replicaset-controller  Created pod: catalog-78d7fd7f6-wq97z
```

## kubectl port-forward deployment/catalog 7080:8080

- **What the command means (simple explanation)**
    - Take the catalog Deployment, pick one of its Pods, and forward traffic from my laptop’s port 7080 to the Pod’s port 8080.

1. **I'm using the Kubernetes CLI.**

2. **This creates a temporary network tunnel between:**
    - My local machine
    - a Pod inside the cluster
    - It’s like plugging a cable from my laptop directly into the Pod.

3. **deployment/catalog**
    - I'm not forwarding to a Pod directly — I'm forwarding to a Deployment.
    - Kubernetes will:
        - Find one Pod managed by the catalog Deployment
        - Attach the port‑forward to that Pod
        - This is convenient because I don’t need to know the Pod name.

4. **7080:8080**
    - This is the port mapping:
        - 7080 → your laptop (local port)
        - 8080 → the container inside the Pod (containerPort)

```sh
# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl port-forward deployment/catalog 7080:8080
Forwarding from 127.0.0.1:7080 -> 8080
Forwarding from [::1]:7080 -> 8080

# ----------------------------------------------------------------------------------------------------------------------------------------
http://localhost:7080/catalog/products
http://localhost:7080/catalog/products/a1258cd2-176c-4507-ade6-746dab5ad625
```

## kubectl scale deployment catalog --replicas=5


```sh
# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
catalog-78d7fd7f6-wq97z   1/1     Running   0          40m
catalog-78d7fd7f6-x25bl   1/1     Running   0          40m
catalog-78d7fd7f6-xq68m   1/1     Running   0          40m

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl scale deployment catalog --replicas=5
deployment.apps/catalog scaled

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
catalog-78d7fd7f6-5gjxm   1/1     Running   0          45s
catalog-78d7fd7f6-nbss7   1/1     Running   0          45s
catalog-78d7fd7f6-wq97z   1/1     Running   0          41m
catalog-78d7fd7f6-x25bl   1/1     Running   0          41m
catalog-78d7fd7f6-xq68m   1/1     Running   0          41m

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl scale deployment catalog --replicas=1
deployment.apps/catalog scaled

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
catalog-78d7fd7f6-x25bl   1/1     Running   0          42m

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl scale deployment catalog --replicas=6
deployment.apps/catalog scaled

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get pods -o wide
NAME                      READY   STATUS    RESTARTS   AGE   IP               NODE
             NOMINATED NODE   READINESS GATES
catalog-78d7fd7f6-6rx8g   1/1     Running   0          14s   192.168.12.237   ip-192-168-12-45.us-east-2.compute.internal   <none>           <none>
catalog-78d7fd7f6-m9jkg   1/1     Running   0          14s   192.168.12.76    ip-192-168-12-45.us-east-2.compute.internal   <none>           <none>
catalog-78d7fd7f6-nqrnr   1/1     Running   0          14s   192.168.11.253   ip-192-168-11-48.us-east-2.compute.internal   <none>           <none>
catalog-78d7fd7f6-s4psn   1/1     Running   0          14s   192.168.11.78    ip-192-168-11-48.us-east-2.compute.internal   <none>           <none>
catalog-78d7fd7f6-tvd9m   1/1     Running   0          14s   192.168.12.177   ip-192-168-12-45.us-east-2.compute.internal   <none>           <none>
catalog-78d7fd7f6-x25bl   1/1     Running   0          44m   192.168.11.104   ip-192-168-11-48.us-east-2.compute.internal   <none>           <none>

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get nodes -o wide
NAME                                          STATUS   ROLES    AGE   VERSION               INTERNAL-IP     EXTERNAL-IP   OS-IMAGE                        KERNEL-VERSION                    CONTAINER-RUNTIME
ip-192-168-11-48.us-east-2.compute.internal   Ready    <none>   77m   v1.34.8-eks-3385e9b   192.168.11.48   <none>        Amazon Linux 2023.11.20260526   6.12.88-119.157.amzn2023.x86_64   containerd://2.2.3+unknown
ip-192-168-12-45.us-east-2.compute.internal   Ready    <none>   77m   v1.34.8-eks-3385e9b   192.168.12.45   <none>        Amazon Linux 2023.11.20260526   6.12.88-119.157.amzn2023.x86_64   containerd://2.2.3+unknown
```

## Update the deployment Image

```sh
# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
catalog-78d7fd7f6-m9jkg   1/1     Running   0          4m10s
catalog-78d7fd7f6-tvd9m   1/1     Running   0          4m10s
catalog-78d7fd7f6-x25bl   1/1     Running   0          48m

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl describe pod catalog-78d7fd7f6-x25bl | grep Image
    Image:          public.ecr.aws/aws-containers/retail-store-sample-catalog:1.0.0
    Image ID:       public.ecr.aws/aws-containers/retail-store-sample-catalog@sha256:b405786f7b0597c81778876d9e4935e7f4cc55d7844ab26b8181f6bfca4ae78a
  Normal  Pulled     48m   kubelet            Successfully pulled image "public.ecr.aws/aws-containers/retail-store-sample-catalog:1.0.0" in 3.798s (3.798s including waiting). Image size: 73856903 bytes.
```

## Update the deployment

```sh
# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl set image deployment/catalog catalog=public.ecr.aws/aws-containers/retail-store-sample-catalog:1.3.0
deployment.apps/catalog image updated

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get pods
NAME                       READY   STATUS    RESTARTS   AGE
catalog-86f7c4bbfc-2z5xb   1/1     Running   0          15s
catalog-86f7c4bbfc-lkhcz   1/1     Running   0          10s
catalog-86f7c4bbfc-nkgl6   1/1     Running   0          16s

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl describe pod catalog-86f7c4bbfc-nkgl6 | grep Image
    Image:          public.ecr.aws/aws-containers/retail-store-sample-catalog:1.3.0
    Image ID:       public.ecr.aws/aws-containers/retail-store-sample-catalog@sha256:b654b266fa32d01aa794274388dc2775563b3a993b6ea17ee33460ca484d8f3f
  Normal  Pulled     29s   kubelet            Successfully pulled image "public.ecr.aws/aws-containers/retail-store-sample-catalog:1.3.0" in 3.869s (3.87s including waiting). Image size: 75515764 bytes.
```

## List Deployment Revision

```sh
# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl rollout history deployment/catalog
deployment.apps/catalog
REVISION  CHANGE-CAUSE
1         <none>
2         <none>

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get rs
NAME                 DESIRED   CURRENT   READY   AGE
catalog-78d7fd7f6    0         0         0       56m
catalog-86f7c4bbfc   3         3         3       4m8s
```

## Rollback to previous version (1.0.0)

```sh
kubectl describe pod catalog-86f7c4bbfc-nkgl6 | grep Image
    Image:          public.ecr.aws/aws-containers/retail-store-sample-catalog:1.3.0
    Image ID:       public.ecr.aws/aws-containers/retail-store-sample-catalog@sha256:b654b266fa32d01aa794274388dc2775563b3a993b6ea17ee33460ca484d8f3f
  Normal  Pulled     29s   kubelet            Successfully pulled image "public.ecr.aws/aws-containers/retail-store-sample-catalog:1.3.0" in 3.869s (3.87s including waiting). Image size: 75515764 bytes.

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl rollout undo deployment/catalog
deployment.apps/catalog rolled back

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get rs
NAME                 DESIRED   CURRENT   READY   AGE
catalog-78d7fd7f6    3         3         3       67m
catalog-86f7c4bbfc   0         0         0       15m

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
catalog-78d7fd7f6-8vkc9   1/1     Running   0          22s
catalog-78d7fd7f6-wkwh5   1/1     Running   0          20s
catalog-78d7fd7f6-xtmhm   1/1     Running   0          22s

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl describe pod catalog-78d7fd7f6-xtmhm | grep Image
    Image:          public.ecr.aws/aws-containers/retail-store-sample-catalog:1.0.0
    Image ID:       public.ecr.aws/aws-containers/retail-store-sample-catalog@sha256:b405786f7b0597c81778876d9e4935e7f4cc55d7844ab26b8181f6bfca4ae78a
```

## Rollback to a specific version

```sh
# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl rollout history deployment/catalog
deployment.apps/catalog
REVISION  CHANGE-CAUSE
2         <none>
3         <none>

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl rollout undo deployment/catalog --to-revision=2
deployment.apps/catalog rolled back

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get pods
NAME                       READY   STATUS    RESTARTS   AGE
catalog-86f7c4bbfc-2drxj   1/1     Running   0          10s
catalog-86f7c4bbfc-8kwpf   1/1     Running   0          9s
catalog-86f7c4bbfc-srnfq   1/1     Running   0          10s

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl describe pod catalog-86f7c4bbfc-srnfq | grep Image
    Image:          public.ecr.aws/aws-containers/retail-store-sample-catalog:1.3.0
    Image ID:       public.ecr.aws/aws-containers/retail-store-sample-catalog@sha256:b654b266fa32d01aa794274388dc2775563b3a993b6ea17ee33460ca484d8f3f

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get rs -o wide
NAME                 DESIRED   CURRENT   READY   AGE    CONTAINERS   IMAGES
                        SELECTOR
catalog-78d7fd7f6    0         0         0       103m   catalog      public.ecr.aws/aws-containers/retail-store-sample-catalog:1.0.0   app.kubernetes.io/name=catalog,pod-template-hash=78d7fd7f6
catalog-86f7c4bbfc   3         3         3       51m    catalog      public.ecr.aws/aws-containers/retail-store-sample-catalog:1.3.0   app.kubernetes.io/name=catalog,pod-template-hash=86f7c4bbfc

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get rs -o wide
NAME                 DESIRED   CURRENT   READY   AGE    CONTAINERS   IMAGES
                        SELECTOR
catalog-78d7fd7f6    0         0         0       103m   catalog      public.ecr.aws/aws-containers/retail-store-sample-catalog:1.0.0   app.kubernetes.io/name=catalog,pod-template-hash=78d7fd7f6
catalog-86f7c4bbfc   3         3         3       51m    catalog      public.ecr.aws/aws-containers/retail-store-sample-catalog:1.3.0   app.kubernetes.io/name=catalog,pod-template-hash=86f7c4bbfc

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl delete -f a01_Catalog_Deployment.yml
deployment.apps "catalog" deleted
```