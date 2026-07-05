# Custom Storage Class and StatefulSet Volume Claim Template

## Tasks:

Here, I will:

- Integrate Amazon EBS CSI Driver with the Catalog MySQL StatefulSet 
- Create a StorageClass backed by EBS volumes for dynamic provisioning 
- Replace emptyDir with real persistent storage for MySQL 
- Verify data persistence across Pod restarts 
- Observe EBS volume lifecycle from creation to deletion 
- Understand how EKS Pod Identity and AWS Secrets Manager integrate with persistent storage

![alt text](image.png)

## Create StorageClass for Amazon EBS

```yml
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-sc
provisioner: ebs.csi.aws.com
volumeBindingMode: WaitForFirstConsumer
```

- **provisioner**: **ebs.csi.aws.com** → Uses the **Amazon EBS CSI Driver**
- **volumeBindingMode**: **WaitForFirstConsumer** → Volume gets **created** only **when the Pod is scheduled**
- Default Delete policy ensures **cleanup of EBS volume when PVC is deleted**

## Updating MySQL StatefulSet to Use EBS Storage

> Key updates:

- Added volumeClaimTemplates to dynamically create a PVC per Pod
- Linked to storageClassName: ebs-sc
- Mounted /var/lib/mysql to persistent EBS-backed volume
- This replaces emptyDir and enables real persistence for MySQL data.

```yml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: catalog-mysql
  labels:
    app.kubernetes.io/name: catalog
    app.kubernetes.io/instance: catalog
    app.kubernetes.io/component: mysql
    app.kubernetes.io/owner: store-sample
spec:
  replicas: 1
  serviceName: catalog-mysql
  selector:
    matchLabels:
      app.kubernetes.io/name: catalog
      app.kubernetes.io/instance: catalog
      app.kubernetes.io/component: mysql
      app.kubernetes.io/owner: store-sample
  template:
    metadata:
      labels:
        app.kubernetes.io/name: catalog
        app.kubernetes.io/instance: catalog
        app.kubernetes.io/component: mysql
        app.kubernetes.io/owner: store-sample
    spec:
      serviceAccount: catalog-mysql-sa # Service Account    
      containers:
        - name: mysql
          image: "public.ecr.aws/docker/library/mysql:8.0"
          imagePullPolicy: IfNotPresent
          ports:
            - name: mysql
              containerPort: 3306
              protocol: TCP          
          env:
            - name: MYSQL_ROOT_PASSWORD
              value: my-secret-pw
            - name: MYSQL_DATABASE
              value: catalogdb
          command: ["/bin/bash", "-c"]
          args:
            - |
              export MYSQL_USER=$(cat /mnt/secrets-store/MYSQL_USER);
              export MYSQL_PASSWORD=$(cat /mnt/secrets-store/MYSQL_PASSWORD);
              echo "Loaded secrets from AWS Secrets Manager. Starting MySQL with user=$MYSQL_USER";
              exec docker-entrypoint.sh mysqld          
          volumeMounts:
            - name: data
              mountPath: /var/lib/mysql
            - name: aws-secrets
              mountPath: /mnt/secrets-store
              readOnly: true              
      volumes:
        #- name: data
        #  emptyDir: {}
        - name: aws-secrets
          csi:
            driver: secrets-store.csi.k8s.io
            readOnly: true
            volumeAttributes:
              secretProviderClass: "catalog-db-secrets"          
# Added for provisioning EBS Volumes              
  volumeClaimTemplates:
    - metadata:
        name: data-ebs
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 10Gi
        storageClassName: ebs-sc   
```

## Deploy and Verify Resources

```sh
kubectl apply -f e10_AWS_Secrets_Manager_Secret_and_SecretProviderClass/
kubectl apply -f e13_Custom_Storage_Class_StatefulSet_VolumeClaimkTemplate_EBS_Deployment/
```

> Use case

```sh
# ----------------------------------------------------------------------------------------------------------
kubectl apply -f e10_AWS_Secrets_Manager_Secret_and_SecretProviderClass/
secretproviderclass.secrets-store.csi.x-k8s.io/catalog-db-secrets unchanged
# ----------------------------------------------------------------------------------------------------------

kubectl apply -f e13_Custom_Storage_Class_StatefulSet_VolumeClaimkTemplate_EBS_Deployment/
deployment.apps/catalog unchanged
service/catalog-service unchanged
configmap/catalog unchanged
service/catalog-mysql unchanged
serviceaccount/catalog-mysql-sa unchanged
storageclass.storage.k8s.io/ebs-sc created
The StatefulSet "catalog-mysql" is invalid: spec: Forbidden: updates to statefulset spec for fields other than 'replicas', 'ordinals', 'template', 'updateStrategy', 'revisionHistoryLimit', 'persistentVolumeClaimRetentionPolicy' and 'minReadySeconds' are forbidden

# ----------------------------------------------------------------------------------------------------------

kubectl delete statefulset catalog-mysql
statefulset.apps "catalog-mysql" deleted

# ----------------------------------------------------------------------------------------------------------

kubectl apply -f e13_Custom_Storage_Class_StatefulSet_VolumeClaimkTemplate_EBS_Deployment/
deployment.apps/catalog unchanged
service/catalog-service unchanged
configmap/catalog unchanged
statefulset.apps/catalog-mysql created
service/catalog-mysql unchanged
serviceaccount/catalog-mysql-sa unchanged
storageclass.storage.k8s.io/ebs-sc unchanged

# ----------------------------------------------------------------------------------------------------------

kubectl get sc
NAME     PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
ebs-sc   ebs.csi.aws.com         Delete          WaitForFirstConsumer   false                  6m43s
gp2      kubernetes.io/aws-ebs   Delete          WaitForFirstConsumer   false                  14h

# ----------------------------------------------------------------------------------------------------------

kubectl get pvc
NAME                       STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
data-ebs-catalog-mysql-0   Bound    pvc-37f6e586-7d9a-479a-b7f0-864c459d0b75   10Gi       RWO            ebs-sc         <unset>                 3m5s

# ----------------------------------------------------------------------------------------------------------

kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                              STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-37f6e586-7d9a-479a-b7f0-864c459d0b75   10Gi       RWO            Delete           Bound    default/data-ebs-catalog-mysql-0   ebs-sc         <unset>                          4m24s

# ----------------------------------------------------------------------------------------------------------

kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
catalog-99cc6fbf4-mgxks   1/1     Running   0          10h
catalog-mysql-0           1/1     Running   0          6m8s

# ----------------------------------------------------------------------------------------------------------

kubectl logs -f catalog-99cc6fbf4-mgxks
Starting Catalog service with secure DB credentials
Using mysql database catalog-mysql-0.catalog-mysql.default.svc.cluster.local:3306
Running database migration...
Database migration complete
[GIN] 2026/06/12 - 15:00:07 | 200 |       83.27µs |       127.0.0.1 | GET      "/topology"
[GIN] 2026/06/12 - 15:00:07 | 404 |     145.008µs |       127.0.0.1 | GET      "/favicon.ico"
[GIN] 2026/06/12 - 15:00:32 | 200 |     2.52889ms |       127.0.0.1 | GET      "/catalog/products"
[GIN] 2026/06/12 - 15:00:40 | 200 |     1.16161ms |       127.0.0.1 | GET      "/catalog/size"
[GIN] 2026/06/12 - 15:00:48 | 200 |     602.345µs |       127.0.0.1 | GET      "/catalog/tags"

# ----------------------------------------------------------------------------------------------------------

kubectl logs -f catalog-mysql-0
Loaded secrets from AWS Secrets Manager. Starting MySQL with user=mydbadmin
2026-06-13 01:04:53+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.46-1.el9 started.
2026-06-13 01:04:53+00:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
2026-06-13 01:04:53+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.46-1.el9 started.
2026-06-13 01:04:53+00:00 [Note] [Entrypoint]: Initializing database files
2026-06-13T01:04:53.615324Z 0 [Warning] [MY-011068] [Server] The syntax '--skip-host-cache' is deprecated and will be removed in a future release. Please use SET GLOBAL host_cache_size=0 instead.
2026-06-13T01:04:53.615424Z 0 [System] [MY-013169] [Server] /usr/sbin/mysqld (mysqld 8.0.46) initializing of server in progress as process 82
2026-06-13T01:04:53.622866Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
2026-06-13T01:04:54.174423Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
2026-06-13T01:04:56.267376Z 6 [Warning] [MY-010453] [Server] root@localhost is created with an empty password ! Please consider switching off the --initialize-insecure option.
2026-06-13 01:05:00+00:00 [Note] [Entrypoint]: Database files initialized
2026-06-13 01:05:00+00:00 [Note] [Entrypoint]: Starting temporary server
2026-06-13T01:05:00.767117Z 0 [Warning] [MY-011068] [Server] The syntax '--skip-host-cache' is deprecated and will be removed in a future release. Please use SET GLOBAL host_cache_size=0 instead.
2026-06-13T01:05:00.769298Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.46) starting as process 124
2026-06-13T01:05:00.786119Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
2026-06-13T01:05:01.149794Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
2026-06-13T01:05:01.921562Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
2026-06-13T01:05:01.921737Z 0 [System] [MY-013602] [Server] Channel mysql_main configured to support TLS. Encrypted connections are now supported for this channel.
2026-06-13T01:05:01.944037Z 0 [Warning] [MY-011810] [Server] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
2026-06-13T01:05:02.003638Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Socket: /var/run/mysqld/mysqlx.sock
2026-06-13T01:05:02.004396Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.46'  socket: '/var/run/mysqld/mysqld.sock'  port: 0  MySQL Community Server - GPL.
2026-06-13 01:05:02+00:00 [Note] [Entrypoint]: Temporary server started.
'/var/lib/mysql/mysql.sock' -> '/var/run/mysqld/mysqld.sock'
Warning: Unable to load '/usr/share/zoneinfo/iso3166.tab' as time zone. Skipping it.
Warning: Unable to load '/usr/share/zoneinfo/leap-seconds.list' as time zone. Skipping it.
Warning: Unable to load '/usr/share/zoneinfo/leapseconds' as time zone. Skipping it.
Warning: Unable to load '/usr/share/zoneinfo/tzdata.zi' as time zone. Skipping it.
Warning: Unable to load '/usr/share/zoneinfo/zone.tab' as time zone. Skipping it.
Warning: Unable to load '/usr/share/zoneinfo/zone1970.tab' as time zone. Skipping it.
2026-06-13 01:05:05+00:00 [Note] [Entrypoint]: Creating database catalogdb
2026-06-13 01:05:05+00:00 [Note] [Entrypoint]: Creating user mydbadmin
2026-06-13 01:05:05+00:00 [Note] [Entrypoint]: Giving user mydbadmin access to schema catalogdb

2026-06-13 01:05:05+00:00 [Note] [Entrypoint]: Stopping temporary server
2026-06-13T01:05:05.745098Z 13 [System] [MY-013172] [Server] Received SHUTDOWN from user root. Shutting down mysqld (Version: 8.0.46).
2026-06-13T01:05:07.585744Z 0 [System] [MY-010910] [Server] /usr/sbin/mysqld: Shutdown complete (mysqld 8.0.46)  MySQL Community Server - GPL.
2026-06-13 01:05:07+00:00 [Note] [Entrypoint]: Temporary server stopped

2026-06-13 01:05:07+00:00 [Note] [Entrypoint]: MySQL init process done. Ready for start up.

2026-06-13T01:05:08.041628Z 0 [Warning] [MY-011068] [Server] The syntax '--skip-host-cache' is deprecated and will be removed in a future release. Please use SET GLOBAL host_cache_size=0 instead.
2026-06-13T01:05:08.043611Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.46) starting as process 1
2026-06-13T01:05:08.050617Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
2026-06-13T01:05:08.353174Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
2026-06-13T01:05:08.591282Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
2026-06-13T01:05:08.591598Z 0 [System] [MY-013602] [Server] Channel mysql_main configured to support TLS. Encrypted connections are now supported for this channel.
2026-06-13T01:05:08.596127Z 0 [Warning] [MY-011810] [Server] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
2026-06-13T01:05:08.635774Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Bind-address: '::' port: 33060, socket: /var/run/mysqld/mysqlx.sock
2026-06-13T01:05:08.635838Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.46'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server - GPL.


# ----------------------------------------------------------------------------------------------------------

kubectl get svc
NAME              TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
catalog-mysql     ClusterIP   None           <none>        3306/TCP   10h
catalog-service   ClusterIP   172.20.22.89   <none>        8080/TCP   10h
kubernetes        ClusterIP   172.20.0.1     <none>        443/TCP    14h

# ----------------------------------------------------------------------------------------------------------

kubectl port-forward svc/catalog-service 7080:8080
Forwarding from 127.0.0.1:7080 -> 8080
Forwarding from [::1]:7080 -> 8080
Handling connection for 7080
Handling connection for 7080
```

## Test Application Connectivity

http://localhost:7080/health

http://localhost:7080/catalog/products

- Confirms Catalog app connects to MySQL using EBS-backed storage.

```sh
kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                              STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-37f6e586-7d9a-479a-b7f0-864c459d0b75   10Gi       RWO            Delete           Bound    default/data-ebs-catalog-mysql-0   ebs-sc         <unset>                          23m
```


## Verify Database Persistence

- Run temporary MySQL client:

```sh
kubectl run mysql-client --rm -it \
  --image=mysql:8.0 \
  --restart=Never \
  -- mysql -h catalog-mysql -u mydbadmin -p

If you don't see a command prompt, try pressing enter.

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.0.46 MySQL Community Server - GPL

Copyright (c) 2000, 2026, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>

# ----------------------------------------------------------------------------------------------------------
# Database Password
Database Password: QwertyNJ2026  
```

## Inside MySQL:



```sh
mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| catalogdb          |
| information_schema |
| performance_schema |
+--------------------+
3 rows in set (0.01 sec)

# ----------------------------------------------------------------------------------------------------------

mysql> USE catalogdb;
Database changed
mysql> SHOW TABLES;
Empty set (0.00 sec)

# ----------------------------------------------------------------------------------------------------------

mysql> CREATE TABLE employees (
    ->     id INT AUTO_INCREMENT PRIMARY KEY,
    ->     first_name VARCHAR(50),
    ->     last_name VARCHAR(50),
    ->     email VARCHAR(100) UNIQUE,
    ->     salary DECIMAL(10,2),
    ->     hire_date DATE
    -> );
Query OK, 0 rows affected (0.04 sec)

# ----------------------------------------------------------------------------------------------------------

mysql> show tables;
+---------------------+
| Tables_in_catalogdb |
+---------------------+
| employees           |
+---------------------+
1 row in set (0.01 sec)
```

## Delete Pod and Verify Data Persistence

- After recreation:
  - Pod auto re-attaches same EBS volume
  - All MySQL data remains intact
    - Confirms true persistent storage behavior.

```sh
kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
catalog-99cc6fbf4-mgxks   1/1     Running   0          11h
catalog-mysql-0           1/1     Running   0          65m

# ----------------------------------------------------------------------------------------------------------
kubectl delete pod catalog-mysql-0
pod "catalog-mysql-0" deleted

# ----------------------------------------------------------------------------------------------------------
kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
catalog-99cc6fbf4-mgxks   1/1     Running   0          11h
catalog-mysql-0           1/1     Running   0          5s

# ----------------------------------------------------------------------------------------------------------
 kubectl run mysql-client --rm -it \
  --image=mysql:8.0 \
  --restart=Never \
  -- mysql -h catalog-mysql -u mydbadmin -p
If you don't see a command prompt, try pressing enter.

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.0.46 MySQL Community Server - GPL

Copyright (c) 2000, 2026, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| catalogdb          |
| information_schema |
| performance_schema |
+--------------------+
3 rows in set (0.01 sec)

mysql> use catalogdb;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+---------------------+
| Tables_in_catalogdb |
+---------------------+
| employees           |
+---------------------+
1 row in set (0.00 sec)

mysql>
```

## Validate EBS Volume Lifecycle

- Delete Kubernetes resources

```sh
kubectl delete -f e10_AWS_Secrets_Manager_Secret_and_SecretProviderClass/
kubectl delete -f e13_Custom_Storage_Class_StatefulSet_VolumeClaimkTemplate_EBS_Deployment/
```

> Use Case

```sh
kubectl delete -f e13_Custom_Storage_Class_StatefulSet_VolumeClaimkTemplate_EBS_Deployment/
deployment.apps "catalog" deleted
service "catalog-service" deleted
configmap "catalog" deleted
statefulset.apps "catalog-mysql" deleted
service "catalog-mysql" deleted
serviceaccount "catalog-mysql-sa" deleted
storageclass.storage.k8s.io "ebs-sc" deleted

# ----------------------------------------------------------------------------------------------------------

kubectl delete -f e10_AWS_Secrets_Manager_Secret_and_SecretProviderClass/
secretproviderclass.secrets-store.csi.x-k8s.io "catalog-db-secrets" deleted
```

## Check PVC & PV

```sh
kubectl get pvc
NAME                       STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
data-ebs-catalog-mysql-0   Bound    pvc-37f6e586-7d9a-479a-b7f0-864c459d0b75   10Gi       RWO            ebs-sc         <unset>                 76m

# ----------------------------------------------------------------------------------------------------------

kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                              STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-37f6e586-7d9a-479a-b7f0-864c459d0b75   10Gi       RWO            Delete           Bound    default/data-ebs-catalog-mysql-0   ebs-sc         <unset>                          76m
```

## Delete PVC manually

EBS volume remains until PVC is deleted.

```sh
kubectl delete pvc data-ebs-catalog-mysql-0
persistentvolumeclaim "data-ebs-catalog-mysql-0" deleted


# ----------------------------------------------------------------------------------------------------------
kubectl get pvc
No resources found in default namespace.

# ----------------------------------------------------------------------------------------------------------
kubectl get pv
No resources found

# ----------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------

```