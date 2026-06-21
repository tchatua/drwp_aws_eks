# Kubetnetes Secrets

Use Kubernetes Secrets to store and manage sensitive information 
Such as database usernames and passwords securely for our Catalog microservice and its MySQL StatefulSet.

```sh
# -----------------------------------------------------------------------------------------------------------------------------------
aws eks --region us-east-2 update-kubeconfig --name south-jersey-eks-tchatua-dev-eks
Updated context arn:aws:eks:us-east-2:088354478627:cluster/south-jersey-eks-tchatua-de\Users\tchat\.kube\config

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl get pods
No resources found in default namespace.

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl apply -f e06_Kubernetes_Secrets/
deployment.apps/catalog created
service/catalog-service created
configmap/catalog-config created
statefulset.apps/catalog-mysql created
service/catalog-mysql created
secret/catalog-db created

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl get pods
NAME                       READY   STATUS    RESTARTS   AGE
catalog-747db6d7db-vzvj5   1/1     Running   0          5s
catalog-mysql-0            1/1     Running   0          5s

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl get secret
NAME         TYPE     DATA   AGE
catalog-db   Opaque   2      58s

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl describe secret catalog-db
Name:         catalog-db
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
CATALOG_PERSISTENCE_PASSWORD:  17 bytes
CATALOG_PERSISTENCE_USER:      11 bytes

# -----------------------------------------------------------------------------------------------------------------------------------
 kubectl logs -f catalog-747db6d7db-vzvj5
Using in-memory database
Running database migration...

2026/06/10 12:16:08 /appsrc/repository/repository.go:71
[0.057ms] [rows:-] SELECT count(*) FROM sqlite_master WHERE type='table' AND name="products"

2026/06/10 12:16:08 /appsrc/repository/repository.go:71
[0.133ms] [rows:0] CREATE TABLE `products` (`id` text,`name` text,`description` text,`price` integer,PRIMARY KEY (`id`))

2026/06/10 12:16:08 /appsrc/repository/repository.go:71
[0.077ms] [rows:-] SELECT count(*) FROM sqlite_master WHERE type='table' AND name="tags"

2026/06/10 12:16:08 /appsrc/repository/repository.go:71
[0.116ms] [rows:0] CREATE TABLE `tags` (`name` text,`display_name` text,PRIMARY KEY (`name`))

2026/06/10 12:16:08 /appsrc/repository/repository.go:71
[0.041ms] [rows:-] SELECT count(*) FROM sqlite_master WHERE type='table' AND name="product_tags"

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl get svc
NAME              TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
catalog-mysql     ClusterIP   None           <none>        3306/TCP   3m59s
catalog-service   ClusterIP   172.20.90.73   <none>        8080/TCP   3m59s
kubernetes        ClusterIP   172.20.0.1     <none>        443/TCP    80m

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl port-forward svc/catalog-service 7080:8080
Forwarding from 127.0.0.1:7080 -> 8080
Forwarding from [::1]:7080 -> 8080

# -----------------------------------------------------------------------------------------------------------------------------------
http://localhost:7080/topology
http://localhost:7080/catalog/products

```