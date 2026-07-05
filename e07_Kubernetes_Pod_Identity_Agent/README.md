# Amazon EKS Pod Identity Agent

## Amazon EKS Pod Identity – High-Level Flow

Amazon EKS Pod Identity enables pods in my cluster to securely assume IAM roles without managing static credentials or using IRSA **(IAM Roles for Service Accounts)** annotations
Implementation of the Amazon EKS Pod Identity Agent (PIA).

## Install the EKS Pod Identity Agent add-on

- Go to `AWS Console` > `Amazon Elastic Kubernetes` > Click on `Clusters` > `Add-ons` > `Get more add-on` > And install `Amazon EKS Pod Identity Agent`

Create a Kubernetes AWS CLI Pod in the EKS Cluster and attempt to list S3 buckets (this will fail initially)
Create an IAM Role with trust policy for Pod Identity → allow Pods to access Amazon S3
Create a Pod Identity Association between the Kubernetes Service Account and IAM Role
Re-test from the AWS CLI Pod, successfully list S3 buckets
Through this flow, we will clearly understand how Pod Identity Agent works in EKS
```sh
# -----------------------------------------------------------------------------------------------------------------------------------
aws eks --region us-east-2 update-kubeconfig --name south-jersey-eks-tchatua-dev-eks-control-plane
Updated context arn:aws:eks:us-east-2:088354478627:cluster/south-jersey-eks-tchatua-dev-eks-control-plane in C:\Users\tchat\.kube\config

# -----------------------------------------------------------------------------------------------------------------------------------
# kubectl get ds -n kube-system
kubectl get daemonset -n kube-system
NAME                     DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
aws-node                 2         2         2       2            2           <none>          35m
eks-pod-identity-agent   2         2         2       2            2           <none>          84s
kube-proxy               2         2         2       2            2           <none>          35m

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl get pods -n kube-system
NAME                           READY   STATUS    RESTARTS   AGE
aws-node-25rlr                 2/2     Running   0          35m
aws-node-g684h                 2/2     Running   0          35m
coredns-64ff95db9-nlmxp        1/1     Running   0          36m
coredns-64ff95db9-vf867        1/1     Running   0          36m
eks-pod-identity-agent-cnmlf   1/1     Running   0          2m12s
eks-pod-identity-agent-klhzf   1/1     Running   0          2m12s
kube-proxy-gjn2b               1/1     Running   0          35m
kube-proxy-kg4tr               1/1     Running   0          35m

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl get pods -n kube-system -o wide
NAME                           READY   STATUS    RESTARTS   AGE   IP               NODE
                   NOMINATED NODE   READINESS GATES
aws-node-25rlr                 2/2     Running   0          36m   192.168.10.230   ip-192-168-10-230.us-east-2.compute.internal   <none>           <none>
aws-node-g684h                 2/2     Running   0          36m   192.168.11.119   ip-192-168-11-119.us-east-2.compute.internal   <none>           <none>
coredns-64ff95db9-nlmxp        1/1     Running   0          38m   192.168.11.140   ip-192-168-11-119.us-east-2.compute.internal   <none>           <none>
coredns-64ff95db9-vf867        1/1     Running   0          38m   192.168.11.83    ip-192-168-11-119.us-east-2.compute.internal   <none>           <none>
eks-pod-identity-agent-cnmlf   1/1     Running   0          4m    192.168.10.230   ip-192-168-10-230.us-east-2.compute.internal   <none>           <none>
eks-pod-identity-agent-klhzf   1/1     Running   0          4m    192.168.11.119   ip-192-168-11-119.us-east-2.compute.internal   <none>           <none>
kube-proxy-gjn2b               1/1     Running   0          36m   192.168.10.230   ip-192-168-10-230.us-east-2.compute.internal   <none>           <none>
kube-proxy-kg4tr               1/1     Running   0          36m   192.168.11.119   ip-192-168-11-119.us-east-2.compute.internal   <none>           <none>

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl get nodes -o wide
NAME                                           STATUS   ROLES    AGE   VERSION               INTERNAL-IP      EXTERNAL-IP   OS-IMAGE                        KERNEL-VERSION                    CONTAINER-RUNTIME
ip-192-168-10-230.us-east-2.compute.internal   Ready    <none>   38m   v1.34.8-eks-3385e9b   192.168.10.230   <none>        Amazon Linux 2023.11.20260526   6.12.88-119.157.amzn2023.x86_64   containerd://2.2.3+unknown
ip-192-168-11-119.us-east-2.compute.internal   Ready    <none>   38m   v1.34.8-eks-3385e9b   192.168.11.119   <none>        Amazon Linux 2023.11.20260526   6.12.88-119.157.amzn2023.x86_64   containerd://2.2.3+unknown

# -----------------------------------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl get pods -n kube-system
NAME                           READY   STATUS    RESTARTS   AGE
aws-node-2qh79                 2/2     Running   0          161m
aws-node-kdq4b                 2/2     Running   0          161m
coredns-64ff95db9-jmwjd        1/1     Running   0          163m
coredns-64ff95db9-knc2k        1/1     Running   0          163m
eks-pod-identity-agent-q897f   1/1     Running   0          3m52s
eks-pod-identity-agent-tvsks   1/1     Running   0          3m52s
kube-proxy-rhmsq               1/1     Running   0          161m
kube-proxy-trszh               1/1     Running   0          161m
```

## Deploy AWS CLI Pod (without Pod Identity Association)

```sh
kubectl apply -f e07_Kubernetes_Pod_Identity_Agent/
serviceaccount/aws-cli-sa created
pod/aws-cli created

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl get sa
NAME         SECRETS   AGE
aws-cli-sa   0         47s
default      0         110m

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl get pods
NAME      READY   STATUS    RESTARTS   AGE
aws-cli   1/1     Running   0          72s
```

## Exec into the pod and try to list S3 buckets:

```sh
kubectl exec -it aws-cli -- aws s3 ls

aws: [ERROR]: An error occurred (NoCredentials): Unable to locate credentials. You can configure credentials by running "aws login".
command terminated with exit code 253
```

## Create Pod Identity Association

- Go to EKS Console → Cluster → Access → Pod Identity Associations
- Create new association:
    - Namespace: default
    - Service Account: aws-cli-sa
    - IAM Role: EKS-PodIdentity-S3-ReadOnly-Role-101
    - Click on create

## Test again

```sh
kubectl get pods
NAME      READY   STATUS    RESTARTS   AGE
aws-cli   1/1     Running   0          35m

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl delete pods aws-cli -n default
pod "aws-cli" deleted

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl apply -f e07_Kubernetes_Pod_Identity_Agent/
serviceaccount/aws-cli-sa unchanged
pod/aws-cli created

# -----------------------------------------------------------------------------------------------------------------------------------
kubectl exec -it aws-cli -- aws s3 ls
2026-04-28 19:27:45 elasticbeanstalk-us-east-2-088354478627
2026-04-28 21:46:58 tchatuabucket12262025
2026-06-06 14:17:53 tfstate-dev-terraformprojects-n5ov6p
```

## Cleaning up

```sh
# -----------------------------------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------------------------------


```