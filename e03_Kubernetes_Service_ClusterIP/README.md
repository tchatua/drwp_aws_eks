# Kubernetes Service: ClusterIP

## Prerequisite: Existing Deployment

```sh
# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get pods
No resources found in default namespace.
# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl apply -f a01_Catalog_Deployment.yml
deployment.apps/catalog created
# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
catalog-78d7fd7f6-5t7tb   1/1     Running   0          12s
catalog-78d7fd7f6-fbn5r   1/1     Running   0          12s
catalog-78d7fd7f6-vnb5c   1/1     Running   0          12s
# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl get rs
NAME                DESIRED   CURRENT   READY   AGE
catalog-78d7fd7f6   3         3         3       94s
# ----------------------------------------------------------------------------------------------------------------------------------------

kubectl get deploy
NAME      READY   UP-TO-DATE   AVAILABLE   AGE
catalog   3/3     3            3           100s
```

## Kubernetes ClusterIP Service

I need to expose internally to my EKS  cluster my deployment to my ClusterIP Service 

```sh
# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get svc
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   172.20.0.1   <none>        443/TCP   3h58m

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl apply -f a02_Catalog_ClusterIP_Service.yml
service/catalog-service created

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get svc
NAME              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
catalog-service   ClusterIP   172.20.187.185   <none>        8080/TCP   9s
kubernetes        ClusterIP   172.20.0.1       <none>        443/TCP    4h12m
```

## Inspect EndpointSlices and Pod Matching

```sh
# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get pods -o wide
NAME                      READY   STATUS    RESTARTS   AGE   IP               NODE
             NOMINATED NODE   READINESS GATES
catalog-78d7fd7f6-5t7tb   1/1     Running   0          13m   192.168.12.76    ip-192-168-12-45.us-east-2.compute.internal   <none>           <none>
catalog-78d7fd7f6-fbn5r   1/1     Running   0          13m   192.168.12.237   ip-192-168-12-45.us-east-2.compute.internal   <none>           <none>
catalog-78d7fd7f6-vnb5c   1/1     Running   0          13m   192.168.11.104   ip-192-168-11-48.us-east-2.compute.internal   <none>           <none>

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get endpointslices
NAME                    ADDRESSTYPE   PORTS   ENDPOINTS                                     AGE
catalog-service-b6spb   IPv4          8080    192.168.12.237,192.168.12.76,192.168.11.104   5m27s
kubernetes              IPv4          443     192.168.10.250,192.168.11.39                  4h17m

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl scale deployment catalog --replicas=9
deployment.apps/catalog scaled

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get pods -o wide
NAME                      READY   STATUS    RESTARTS   AGE   IP               NODE
             NOMINATED NODE   READINESS GATES
catalog-78d7fd7f6-5t7tb   1/1     Running   0          17m   192.168.12.76    ip-192-168-12-45.us-east-2.compute.internal   <none>           <none>
catalog-78d7fd7f6-95mmg   1/1     Running   0          5s    192.168.12.201   ip-192-168-12-45.us-east-2.compute.internal   <none>           <none>
catalog-78d7fd7f6-fbn5r   1/1     Running   0          17m   192.168.12.237   ip-192-168-12-45.us-east-2.compute.internal   <none>           <none>
catalog-78d7fd7f6-gbqsm   1/1     Running   0          5s    192.168.12.177   ip-192-168-12-45.us-east-2.compute.internal   <none>           <none>
catalog-78d7fd7f6-n6l5f   1/1     Running   0          5s    192.168.11.182   ip-192-168-11-48.us-east-2.compute.internal   <none>           <none>
catalog-78d7fd7f6-q7qbx   1/1     Running   0          5s    192.168.11.253   ip-192-168-11-48.us-east-2.compute.internal   <none>           <none>
catalog-78d7fd7f6-vnb5c   1/1     Running   0          17m   192.168.11.104   ip-192-168-11-48.us-east-2.compute.internal   <none>           <none>
catalog-78d7fd7f6-zb8qg   1/1     Running   0          5s    192.168.11.63    ip-192-168-11-48.us-east-2.compute.internal   <none>           <none>
catalog-78d7fd7f6-zknwh   1/1     Running   0          5s    192.168.12.211   ip-192-168-12-45.us-east-2.compute.internal   <none>

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl get endpointslices
NAME                    ADDRESSTYPE   PORTS   ENDPOINTS                                                 AGE
catalog-service-b6spb   IPv4          8080    192.168.12.237,192.168.12.76,192.168.11.104 + 6 more...   7m54s
kubernetes              IPv4          443     192.168.10.250,192.168.11.39                              4h20m

# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl describe endpointslices catalog-service-b6spb
Name:         catalog-service-b6spb
Namespace:    default
Labels:       app.kubernetes.io/name=catalog
              endpointslice.kubernetes.io/managed-by=endpointslice-controller.k8s.io
              kubernetes.io/service-name=catalog-service
Annotations:  endpoints.kubernetes.io/last-change-trigger-time: 2026-06-09T23:10:13Z
AddressType:  IPv4
Ports:
  Name  Port  Protocol
  ----  ----  --------
  http  8080  TCP
Endpoints:
  - Addresses:  192.168.12.237
    Conditions:
      Ready:    true
    Hostname:   <unset>
    TargetRef:  Pod/catalog-78d7fd7f6-fbn5r
    NodeName:   ip-192-168-12-45.us-east-2.compute.internal
    Zone:       us-east-2c
  - Addresses:  192.168.12.76
    Conditions:
      Ready:    true
    Hostname:   <unset>
    TargetRef:  Pod/catalog-78d7fd7f6-5t7tb
    NodeName:   ip-192-168-12-45.us-east-2.compute.internal
    Zone:       us-east-2c
  - Addresses:  192.168.11.104
    Conditions:
      Ready:    true
    Hostname:   <unset>
    TargetRef:  Pod/catalog-78d7fd7f6-vnb5c
    NodeName:   ip-192-168-11-48.us-east-2.compute.internal
    Zone:       us-east-2b
  - Addresses:  192.168.12.201
    Conditions:
      Ready:    true
    Hostname:   <unset>
    TargetRef:  Pod/catalog-78d7fd7f6-95mmg
    NodeName:   ip-192-168-12-45.us-east-2.compute.internal
    Zone:       us-east-2c
  - Addresses:  192.168.12.177
    Conditions:
      Ready:    true
    Hostname:   <unset>
    TargetRef:  Pod/catalog-78d7fd7f6-gbqsm
    NodeName:   ip-192-168-12-45.us-east-2.compute.internal
    Zone:       us-east-2c
  - Addresses:  192.168.12.211
    Conditions:
      Ready:    true
    Hostname:   <unset>
    TargetRef:  Pod/catalog-78d7fd7f6-zknwh
    NodeName:   ip-192-168-12-45.us-east-2.compute.internal
    Zone:       us-east-2c
  - Addresses:  192.168.11.63
    Conditions:
      Ready:    true
    Hostname:   <unset>
    TargetRef:  Pod/catalog-78d7fd7f6-zb8qg
    NodeName:   ip-192-168-11-48.us-east-2.compute.internal
    Zone:       us-east-2b
  - Addresses:  192.168.11.182
    Conditions:
      Ready:    true
    Hostname:   <unset>
    TargetRef:  Pod/catalog-78d7fd7f6-n6l5f
    NodeName:   ip-192-168-11-48.us-east-2.compute.internal
    Zone:       us-east-2b
  - Addresses:  192.168.11.253
    Conditions:
      Ready:    true
    Hostname:   <unset>
    TargetRef:  Pod/catalog-78d7fd7f6-q7qbx
    NodeName:   ip-192-168-11-48.us-east-2.compute.internal
    Zone:       us-east-2b
Events:         <none>
```

## Connectivity from inside the Cluster (Internal Connectivity Test)

> Run a test Pod inside the same namesapce

```sh
# ----------------------------------------------------------------------------------------------------------------------------------------
kubectl run test --image=curlimages/curl -it --rm -- sh
If you don't see a command prompt, try pressing enter.
~ $ curl http://catalog-service:8080/topology
~ $
~ $
{"databaseEndpoint":"N/A","persistenceProvider":"in-memory"}~ $
~ $
~ $
$ curl http://catalog-service:8080/health
OK~ $
~ $ curl http://catalog-service:8080/catalog/products
[{"id":"a1258cd2-176c-4507-ade6-746dab5ad625","name":"Aqua Ace GT","description":"Transform your luxury sports car into a high-speed submarine with the push of a button. Features hydro-jet propulsion, underwater navigation, and oxygen recycling system for up to 8 hours. Includes coral-proof paint coating.","price":10000,"tags":[{"name":"vehicles","displayName":"Vehicles"}]},{"id":"d4edfedb-dbe9-4dd9-aae8-009489394955","name":"Audio-Illusion Spinner","description":"Professional-grade sonic illusion generator disguised as a simple yo-yo. Creates realistic sound effects from footsteps to full orchestras. Includes comprehensive training manual and anti-tangle technology.","price":190,"tags":[{"name":"accessories","displayName":"Accessories"}]},{"id":"79bce3f3-935f-4912-8c62-0d2f3e059405","name":"Facechanger Formal Wear","description":"Transform your appearance instantly with this high-tech bowtie. Features 100 pre-loaded faces, custom face scanning capability, and voice modulation. Battery lasts up to 8 hours on a single charge.","price":70,"tags":[{"name":"clothing","displayName":"Clothing"}]},{"id":"8757729a-c518-4356-8694-9e795a9b3237","name":"Forget-Me-Pop","description":"This innovative bubblegum creates localized amnesia in your target for 5 minutes per piece. Features three brain-tingling flavors: Forgotten Fruit, Mindwipe Mint, and Blank-Berry. Includes warning label: Do not accidentally pop bubble on yourself.","price":20,"tags":[{"name":"food","displayName":"Food"}]},{"id":"4f18544b-70a5-4352-8e19-0d070f46745d","name":"Levitator Oxfords","description":"Classic Oxford-style shoes concealing cutting-edge anti-gravity technology. Features wall-walking capability, ceiling-escape mode, and auto-stabilization. Available in black or brown. Not recommended for formal dances.","price":210,"tags":[{"name":"clothing","displayName":"Clothing"}]},{"id":"d77f9ae6-e9a8-4a3e-86bd-b72af75cbc49","name":"Phantom Pursuit","description":"Create perfect duplicates of your vehicle to confuse pursuers. Features multi-angle projection, realistic physics simulation, and remote control capability. Includes tactical evasion manual.","price":15000,"tags":[{"name":"vehicles","displayName":"Vehicles"}]},{"id":"d3104128-1d14-4465-99d3-8ab9267c687b","name":"SkyCycle X-1000","description":"Switch from road to air travel instantly with this cutting-edge motorcycle. Features vertical takeoff capability, stealth mode, and auto-stabilization system. Includes emergency parachute and cloud-navigation GPS.","price":9000,"tags":[{"name":"vehicles","displayName":"Vehicles"}]},{"id":"cc789f85-1476-452a-8100-9e74502198e0","name":"Temporal Tickstopper","description":"Stop time for 30 seconds with this vintage-styled pocket watch. Features mechanical wind-up power reserve and temporal disruption failsafe. Includes leather carrying pouch and temporal paradox insurance.","price":250,"tags":[{"name":"accessories","displayName":"Accessories"}]},{"id":"1ca35e86-4b4c-4124-b6b5-076ba4134d0d","name":"The Forgetter MK-II","description":"These stylish shades pack a powerful amnesia-inducing flash that erases the last 60 seconds of memory from anyone in view. Includes UV protection and auto-darkening lenses. Not recommended for use during important meetings.","price":225,"tags":[{"name":"accessories","displayName":"Accessories"}]},{"id":"631a3db5-ac07-492c-a994-8cd56923c112","name":"The Morning Teleporter","description":"Create instant portals to pre-programmed locations with this ceramic marvel. Perfect for quick escapes or coffee runs. Features thermal insulation and spill-proof portal containment. Dishwasher safe on low heat.","price":40,"tags":[{"name":"accessories","displayName":"Accessories"}]}]~ $
~ $
~ $
~ $ curl http://catalog-service:8080/catalog/size
{"size":12}~ $
~ $
~ $
~ $ curl http://catalog-service:8080/catalog/tags
[{"name":"accessories","displayName":"Accessories"},{"name":"clothing","displayName":"Clothing"},{"name":"food","displayName":"Food"},{"name":"vehicles","displayName":"Vehicles"}]~ $
~ $
~ $
~ $ exit
Session ended, resume using 'kubectl attach test -c test -i -t' command when the pod is running
pod "test" deleted
```

## DNS Resolution Check

**This proves that even though our pods have dynamic IPs, we can consistently reach the catalog application using the service name.**

```sh
# ----------------------------------------------------------------------------------------------------------------------------------------
# kubectl run dns-test --image=busybox:1.28 -it --rm
kubectl run dns-test --image=busybox:1.28 -it --rm
If you don't see a command prompt, try pressing enter.
/ # 
/ # 
/ # nslookup catalog-service
Server:    172.20.0.10
Address 1: 172.20.0.10 kube-dns.kube-system.svc.cluster.local

Name:      catalog-service
Address 1: 172.20.187.185 catalog-service.default.svc.cluster.local
/ #
/ # 
/ #
/ # 
/ #
/ # 
/ #
/ # 
/ #
/ # 
/ #
/ # 
# ----------------------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------------------

```