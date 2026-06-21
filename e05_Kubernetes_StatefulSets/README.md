# Kubernetes StatefulSets

## MySQL Master - Slave Replication


```sh
kubectl apply -f e05_Kubernetes_StatefulSets/
deployment.apps/catalog created
service/catalog-service created
configmap/catalog-config created
statefulset.apps/catalog-mysql created
service/catalog-mysql created

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl get sts
NAME            READY   AGE
catalog-mysql   1/1     78s

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl get pods -o wide
NAME                       READY   STATUS    RESTARTS   AGE    IP               NODE
               NOMINATED NODE   READINESS GATES
catalog-5bdfc68d48-fxb55   1/1     Running   0          109s   192.168.12.142   ip-192-168-12-45.us-east-2.compute.internal   <none>           <none>
catalog-mysql-0            1/1     Running   0          109s   192.168.11.182   ip-192-168-11-48.us-east-2.compute.internal   <none>           <none>

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl logs -f catalog-5bdfc68d48-fxb55
Using in-memory database
Running database migration...

2026/06/10 02:26:34 /appsrc/repository/repository.go:71
[0.052ms] [rows:-] SELECT count(*) FROM sqlite_master WHERE type='table' AND name="products"

2026/06/10 02:26:34 /appsrc/repository/repository.go:71
[0.149ms] [rows:0] CREATE TABLE `products` (`id` text,`name` text,`description` text,`price` integer,PRIMARY KEY (`id`))

2026/06/10 02:26:34 /appsrc/repository/repository.go:71
[0.028ms] [rows:-] SELECT count(*) FROM sqlite_master WHERE type='table' AND name="tags"

2026/06/10 02:26:34 /appsrc/repository/repository.go:71
[0.120ms] [rows:0] CREATE TABLE `tags` (`name` text,`display_name` text,PRIMARY KEY (`name`))

2026/06/10 02:26:34 /appsrc/repository/repository.go:71
[0.034ms] [rows:-] SELECT count(*) FROM sqlite_master WHERE type='table' AND name="product_tags"

2026/06/10 02:26:34 /appsrc/repository/repository.go:71
[0.113ms] [rows:0] CREATE TABLE `product_tags` (`product_id` text,`tag_name` text,PRIMARY KEY (`product_id`,`tag_name`),CONSTRAINT `fk_product_tags_product` FOREIGN KEY (`product_id`) REFERENCES `products`(`id`),CONSTRAINT `fk_product_tags_tag` FOREIGN KEY (`tag_name`) REFERENCES `tags`(`name`))
Database migration complete

2026/06/10 02:26:34 /appsrc/repository/repository.go:91
[0.110ms] [rows:0] UPDATE `tags` SET `name`="accessories",`display_name`="Accessories" WHERE `name` = "accessories"

2026/06/10 02:26:34 /appsrc/repository/repository.go:91
[0.091ms] [rows:1] INSERT INTO `tags` (`name`,`display_name`) VALUES ("accessories","Accessories") ON CONFLICT (`name`) DO UPDATE SET `display_name`=`excluded`.`display_name`

2026/06/10 02:26:34 /appsrc/repository/repository.go:91
[0.066ms] [rows:0] UPDATE `tags` SET `name`="clothing",`display_name`="Clothing" WHERE `name` = "clothing"

2026/06/10 02:26:34 /appsrc/repository/repository.go:91
[0.111ms] [rows:1] INSERT INTO `tags` (`name`,`display_name`) VALUES ("clothing","Clothing") ON CONFLICT (`name`) DO UPDATE SET `display_name`=`excluded`.`display_name`

2026/06/10 02:26:34 /appsrc/repository/repository.go:91
[0.065ms] [rows:0] UPDATE `tags` SET `name`="food",`display_name`="Food" WHERE `name` = "food"

2026/06/10 02:26:34 /appsrc/repository/repository.go:91
[0.081ms] [rows:1] INSERT INTO `tags` (`name`,`display_name`) VALUES ("food","Food") ON CONFLICT (`name`) DO UPDATE SET `display_name`=`excluded`.`display_name`

2026/06/10 02:26:34 /appsrc/repository/repository.go:91
[0.062ms] [rows:0] UPDATE `tags` SET `name`="vehicles",`display_name`="Vehicles" WHERE `name` = "vehicles"

2026/06/10 02:26:34 /appsrc/repository/repository.go:91
[0.076ms] [rows:1] INSERT INTO `tags` (`name`,`display_name`) VALUES ("vehicles","Vehicles") ON CONFLICT (`name`) DO UPDATE SET `display_name`=`excluded`.`display_name`
```

## DNS Testing

```sh
$ kubectl run dns-test --image=busybox:1.28 -it --rm
If you don't see a command prompt, try pressing enter.
/ #
/ #
/ # nslookup catalog-mysql
Server:    172.20.0.10
Address 1: 172.20.0.10 kube-dns.kube-system.svc.cluster.local

Name:      catalog-mysql
Address 1: 192.168.11.182 catalog-mysql-0.catalog-mysql.default.svc.cluster.local
/ #
/ #
```

##

```sh
kubectl delete -f e05_Kubernetes_StatefulSets/
deployment.apps "catalog" deleted
service "catalog-service" deleted
configmap "catalog-config" deleted
statefulset.apps "catalog-mysql" deleted
service "catalog-mysql" deleted

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl apply -f e05_Kubernetes_StatefulSets/
deployment.apps/catalog created
service/catalog-service created
configmap/catalog-config created
statefulset.apps/catalog-mysql created
service/catalog-mysql created

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl logs -f catalog-5bdfc68d48-fxb55
Using in-memory database
Running database migration...

2026/06/10 02:26:34 /appsrc/repository/repository.go:71
[0.052ms] [rows:-] SELECT count(*) FROM sqlite_master WHERE type='table' AND name="products"

2026/06/10 02:26:34 /appsrc/repository/repository.go:71
[0.149ms] [rows:0] CREATE TABLE `products` (`id` text,`name` text,`description` text,`price` integer,PRIMARY KEY (`id`))

2026/06/10 02:26:34 /appsrc/repository/repository.go:71
[0.028ms] [rows:-] SELECT count(*) FROM sqlite_master WHERE type='table' AND name="tags"

2026/06/10 02:26:34 /appsrc/repository/repository.go:71
[0.120ms] [rows:0] CREATE TABLE `tags` (`name` text,`display_name` text,PRIMARY KEY (`name`))

2026/06/10 02:26:34 /appsrc/repository/repository.go:71
[0.034ms] [rows:-] SELECT count(*) FROM sqlite_master WHERE type='table' AND name="product_tags"

2026/06/10 02:26:34 /appsrc/repository/repository.go:71
[0.113ms] [rows:0] CREATE TABLE `product_tags` (`product_id` text,`tag_name` text,PRIMARY KEY (`product_id`,`tag_name`),CONSTRAINT `fk_product_tags_product` FOREIGN KEY (`product_id`) REFERENCES `products`(`id`),CONSTRAINT `fk_product_tags_tag` FOREIGN KEY (`tag_name`) REFERENCES `tags`(`name`))
Database migration complete

2026/06/10 02:26:34 /appsrc/repository/repository.go:91
[0.110ms] [rows:0] UPDATE `tags` SET `name`="accessories",`display_name`="Accessories" WHERE `name` = "accessories"
```

## Scale Up – Ordered Pod Creation

```sh
kubectl get pods
NAME                       READY   STATUS    RESTARTS   AGE
catalog-5bdfc68d48-587t7   1/1     Running   0          14s
catalog-mysql-0            1/1     Running   0          14s

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl scale statefulset catalog-mysql --replicas=3
statefulset.apps/catalog-mysql scaled

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl get pods
NAME                       READY   STATUS    RESTARTS   AGE
catalog-5bdfc68d48-587t7   1/1     Running   0          41s
catalog-mysql-0            1/1     Running   0          41s
catalog-mysql-1            1/1     Running   0          17s
catalog-mysql-2            1/1     Running   0          4s

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl get pods -o wide
NAME                       READY   STATUS    RESTARTS   AGE   IP               NODE
              NOMINATED NODE   READINESS GATES
catalog-5bdfc68d48-587t7   1/1     Running   0          97s   192.168.11.104   ip-192-168-11-48.us-east-2.compute.internal   <none>           <none>
catalog-mysql-0            1/1     Running   0          97s   192.168.11.182   ip-192-168-11-48.us-east-2.compute.internal   <none>           <none>
catalog-mysql-1            1/1     Running   0          73s   192.168.12.76    ip-192-168-12-45.us-east-2.compute.internal   <none>           <none>
catalog-mysql-2            1/1     Running   0          60s   192.168.11.253   ip-192-168-11-48.us-east-2.compute.internal   <none>           <none>

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl get pods -w
NAME                       READY   STATUS    RESTARTS   AGE
catalog-5bdfc68d48-587t7   1/1     Running   0          2m10s
catalog-mysql-0            1/1     Running   0          2m10s
catalog-mysql-1            1/1     Running   0          106s
catalog-mysql-2            1/1     Running   0          93s
```

## Scale Down – Reverse Order Deletion

```sh
kubectl scale statefulset catalog-mysql --replicas=1
statefulset.apps/catalog-mysql scaled
```

## Observation Note: VERY IMPORTANT

- Since the MySQL database Pod uses an emptyDir volume, the data stored inside the Pod is ephemeral — it exists only for the Pod’s lifetime.
- When I delete and recreate the Pod, the entire database is reinitialized, and any previously created data (for example, products, tags, etc.) is lost.
- This clearly demonstrates why I need persistent storage — which I’ll address later using **EBS CSI Driver and PersistentVolumeClaims**.

## StatefulSet Scaling ≠ MySQL Replication

- Scaling MySQL StatefulSet to multiple replicas only creates independent MySQL servers. Kubernetes does not configure replication automatically.
- To build master–replica replication, I need:
    - Custom init scripts or sidecar containers
    - Commands like CHANGE MASTER TO and START SLAVE;
    - Or use Bitnami MySQL Helm Chart, which sets up replication automatically.
- StatefulSet gives identity and stability; replication logic must be handled separately.

## Verify Database Connection Inside Cluster

## Connect Using MySQL Client Pod

```sh
kubectl get pods
NAME                       READY   STATUS    RESTARTS   AGE
catalog-5bdfc68d48-587t7   1/1     Running   0          15m
catalog-mysql-0            1/1     Running   0          15m

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl run mysql-client --rm -it \
  --image=mysql:8.0 \
  --restart=Never \
  -- mysql -h catalog-mysql -u catalog_user -p

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl exec -it catalog-mysql-0 -- bash
bash-5.1#
bash-5.1#
bash-5.1# mysql -u catalog_user -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 12
Server version: 8.0.46 MySQL Community Server - GPL

Copyright (c) 2000, 2026, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
mysql>
mysql> show schemas;
+--------------------+
| Database           |
+--------------------+
| catalogdb          |
| information_schema |
| performance_schema |
+--------------------+
3 rows in set (0.00 sec)

```

>

