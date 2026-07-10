#

```sh
helm list -n kube-system
NAME                            NAMESPACE       REVISION        UPDATED                                 STATUS         CHART                                           APP VERSION
aws-load-balancer-controller    kube-system     1               2026-07-07 20:59:08.6723898 -0400 EDT   deployed       aws-load-balancer-controller-3.4.1              v3.4.1
csi-secrets-store               kube-system     1               2026-07-07 20:59:07.7919939 -0400 EDT   deployed       secrets-store-csi-driver-1.6.0                  1.6.0
karpenter                       kube-system     1               2026-07-07 21:19:30.2431399 -0400 EDT   deployed       karpenter-1.8.2                                 1.8.2
secrets-provider-aws            kube-system     1               2026-07-07 20:59:30.7474383 -0400 EDT   deployed       secrets-store-csi-driver-provider-aws-3.1.1

# #######################################################################################################################################################

helm status karpenter -n kube-system
NAME: karpenter
LAST DEPLOYED: Tue Jul  7 21:19:30 2026
NAMESPACE: kube-system
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
RESOURCES:
==> v1/ClusterRoleBinding
NAME             ROLE                         AGE
karpenter-core   ClusterRole/karpenter-core   8m15s
karpenter   ClusterRole/karpenter   8m15s

==> v1/Role
NAME        CREATED AT
karpenter   2026-07-08T01:19:33Z
karpenter-dns   2026-07-08T01:19:33Z

==> v1/Pod(related)
NAME                         READY   STATUS    RESTARTS        AGE
karpenter-779fc6f565-kpkjg   1/1     Running   1 (8m13s ago)   8m16s
karpenter-779fc6f565-snhz6   1/1     Running   0               8m16s

==> v1/PodDisruptionBudget
NAME        MIN AVAILABLE   MAX UNAVAILABLE   ALLOWED DISRUPTIONS   AGE
karpenter   N/A             1                 1                     8m16s

==> v1/ServiceAccount
NAME        SECRETS   AGE
karpenter   0         8m16s

==> v1/ClusterRole
NAME              CREATED AT
karpenter-admin   2026-07-08T01:19:33Z
karpenter-core   2026-07-08T01:19:33Z
karpenter   2026-07-08T01:19:33Z

==> v1/RoleBinding
NAME        ROLE             AGE
karpenter   Role/karpenter   8m15s
karpenter-dns   Role/karpenter-dns   8m15s

==> v1/Service
NAME        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
karpenter   ClusterIP   172.20.27.108   <none>        8080/TCP   8m15s

==> v1/Deployment
NAME        READY   UP-TO-DATE   AVAILABLE   AGE
karpenter   2/2     2            2           8m15s


TEST SUITE: None

# #######################################################################################################################################################

kubectl get pods -n kube-system
NAME                                                              READY   STATUS    RESTARTS        AGE
aws-load-balancer-controller-86486fb897-9dlg4                     1/1     Running   0               29m
aws-load-balancer-controller-86486fb897-ftmss                     1/1     Running   0               29m
aws-node-mtbcv                                                    2/2     Running   0               31m
aws-node-mvbmv                                                    2/2     Running   0               31m
aws-node-whgws                                                    2/2     Running   0               30m
coredns-6d6c454fdb-dgrh2                                          1/1     Running   0               32m
coredns-6d6c454fdb-tkllw                                          1/1     Running   0               32m
csi-secrets-store-secrets-store-csi-driver-rmw4j                  3/3     Running   0               29m
csi-secrets-store-secrets-store-csi-driver-rvzmp                  3/3     Running   0               29m
csi-secrets-store-secrets-store-csi-driver-w422d                  3/3     Running   0               29m
ebs-csi-controller-664cb96c56-btk5z                               6/6     Running   0               29m
ebs-csi-controller-664cb96c56-lsdgx                               6/6     Running   0               29m
ebs-csi-node-2sx8n                                                3/3     Running   0               29m
ebs-csi-node-9wbz9                                                3/3     Running   0               29m
ebs-csi-node-xk9dj                                                3/3     Running   0               29m
eks-pod-identity-agent-j4f86                                      1/1     Running   0               30m
eks-pod-identity-agent-j7z5x                                      1/1     Running   0               30m
eks-pod-identity-agent-zssr6                                      1/1     Running   0               30m
karpenter-779fc6f565-kpkjg                                        1/1     Running   1 (9m18s ago)   9m21s
karpenter-779fc6f565-snhz6                                        1/1     Running   0               9m21s
kube-proxy-f5tf4                                                  1/1     Running   0               31m
kube-proxy-h5v6k                                                  1/1     Running   0               31m
kube-proxy-nxrjm                                                  1/1     Running   0               30m
secrets-provider-aws-secrets-store-csi-driver-provider-aws7gkmh   1/1     Running   0               29m
secrets-provider-aws-secrets-store-csi-driver-provider-awsmz57j   1/1     Running   0               29m
secrets-provider-aws-secrets-store-csi-driver-provider-awsvw78f   1/1     Running   0               29m


# #######################################################################################################################################################

 kubectl -n kube-system logs -f karpenter-779fc6f565-kpkjg
{"level":"INFO","time":"2026-07-08T01:19:38.183Z","logger":"controller.controller-runtime.metrics","message":"Starting metrics server","commit":"f913f41"}
{"level":"INFO","time":"2026-07-08T01:19:38.183Z","logger":"controller.controller-runtime.metrics","message":"Serving metrics server","commit":"f913f41","bindAddress":":8080","secure":false}
{"level":"INFO","time":"2026-07-08T01:19:38.183Z","logger":"controller","message":"starting server","commit":"f913f41","name":"health probe","addr":"[::]:8081"}
{"level":"INFO","time":"2026-07-08T01:19:38.285Z","logger":"controller","message":"attempting to acquire leader lease kube-system/karpenter-leader-election...","commit":"f913f41"}

# #######################################################################################################################################################

kubectl -n kube-system logs -f -l app.kubernetes.io/name=karpenter
{"level":"INFO","time":"2026-07-08T01:19:38.183Z","logger":"controller.controller-runtime.metrics","message":"Starting metrics server","commit":"f913f41"}
{"level":"INFO","time":"2026-07-08T01:19:38.183Z","logger":"controller.controller-runtime.metrics","message":"Serving metrics server","commit":"f913f41","bindAddress":":8080","secure":false}
{"level":"INFO","time":"2026-07-08T01:19:38.183Z","logger":"controller","message":"starting server","commit":"f913f41","name":"health probe","addr":"[::]:8081"}
{"level":"INFO","time":"2026-07-08T01:19:38.285Z","logger":"controller","message":"attempting to acquire leader lease kube-system/karpenter-leader-election...","commit":"f913f41"}
{"level":"INFO","time":"2026-07-08T01:19:38.111Z","logger":"controller","message":"Starting Controller","commit":"f913f41","controller":"nodeclass","controllerGroup":"karpenter.k8s.aws","controllerKind":"EC2NodeClass"}
{"level":"INFO","time":"2026-07-08T01:19:38.111Z","logger":"controller","message":"Starting workers","commit":"f913f41","controller":"nodeclass","controllerGroup":"karpenter.k8s.aws","controllerKind":"EC2NodeClass","worker count":10}
{"level":"INFO","time":"2026-07-08T01:19:38.112Z","logger":"controller","message":"Starting Controller","commit":"f913f41","controller":"nodeclass.hash","controllerGroup":"karpenter.k8s.aws","controllerKind":"EC2NodeClass"}
{"level":"INFO","time":"2026-07-08T01:19:38.112Z","logger":"controller","message":"Starting workers","commit":"f913f41","controller":"nodeclass.hash","controllerGroup":"karpenter.k8s.aws","controllerKind":"EC2NodeClass","worker count":10}
{"level":"INFO","time":"2026-07-08T01:19:38.114Z","logger":"controller","message":"Starting Controller","commit":"f913f41","controller":"operatorpkg.ec2nodeclass.status","controllerGroup":"karpenter.k8s.aws","controllerKind":"EC2NodeClass"}
{"level":"INFO","time":"2026-07-08T01:19:38.114Z","logger":"controller","message":"Starting workers","commit":"f913f41","controller":"operatorpkg.ec2nodeclass.status","controllerGroup":"karpenter.k8s.aws","controllerKind":"EC2NodeClass","worker count":10}
{"level":"INFO","time":"2026-07-08T01:19:38.115Z","logger":"controller","message":"Starting Controller","commit":"f913f41","controller":"nodeclaim.tagging","controllerGroup":"karpenter.sh","controllerKind":"NodeClaim"}
{"level":"INFO","time":"2026-07-08T01:19:38.115Z","logger":"controller","message":"Starting workers","commit":"f913f41","controller":"nodeclaim.tagging","controllerGroup":"karpenter.sh","controllerKind":"NodeClaim","worker count":1}
{"level":"INFO","time":"2026-07-08T01:19:38.115Z","logger":"controller","message":"Starting Controller","commit":"f913f41","controller":"providers.instancetype.capacity","controllerGroup":"","controllerKind":"Node"}
{"level":"INFO","time":"2026-07-08T01:19:38.115Z","logger":"controller","message":"Starting workers","commit":"f913f41","controller":"providers.instancetype.capacity","controllerGroup":"","controllerKind":"Node","worker count":1}

# #######################################################################################################################################################

kubectl get sa -n kube-system
NAME                                                         SECRETS   AGE
attachdetach-controller                                      0         48m
aws-cloud-provider                                           0         48m
aws-load-balancer-controller                                 0         44m
aws-node                                                     0         47m
certificate-controller                                       0         48m
clusterrole-aggregation-controller                           0         48m
coredns                                                      0         47m
cronjob-controller                                           0         48m
daemon-set-controller                                        0         48m
default                                                      0         48m
deployment-controller                                        0         48m
disruption-controller                                        0         48m
ebs-csi-controller-sa                                        0         44m
ebs-csi-node-sa                                              0         44m
endpoint-controller                                          0         48m
endpointslice-controller                                     0         48m
endpointslicemirroring-controller                            0         48m
ephemeral-volume-controller                                  0         48m
expand-controller                                            0         48m
generic-garbage-collector                                    0         48m
horizontal-pod-autoscaler                                    0         48m
job-controller                                               0         48m
karpenter                                                    0         24m
kube-proxy                                                   0         47m
legacy-service-account-token-cleaner                         0         48m
namespace-controller                                         0         48m
node-controller                                              0         48m
persistent-volume-binder                                     0         48m
pod-garbage-collector                                        0         48m
pv-protection-controller                                     0         48m
pvc-protection-controller                                    0         48m
replicaset-controller                                        0         48m
replication-controller                                       0         48m
resource-claim-controller                                    0         48m
resourcequota-controller                                     0         48m
root-ca-cert-publisher                                       0         48m
secrets-provider-aws-secrets-store-csi-driver-provider-aws   0         44m
secrets-store-csi-driver                                     0         44m
service-account-controller                                   0         48m
service-cidrs-controller                                     0         48m
service-controller                                           0         48m
statefulset-controller                                       0         48m
tagging-controller                                           0         48m
ttl-after-finished-controller                                0         48m
ttl-controller                                               0         48m
validatingadmissionpolicy-status-controller                  0         48m
volumeattributesclass-protection-controller                  0         48m

# #######################################################################################################################################################

kubectl get sa -n kube-system | grep karp
karpenter                                                    0         24m

# #######################################################################################################################################################

# #######################################################################################################################################################

# #######################################################################################################################################################

# #######################################################################################################################################################

# #######################################################################################################################################################

```