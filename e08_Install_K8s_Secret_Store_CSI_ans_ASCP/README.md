# Install AWS Secrets and Configuration Provider (ASCP) for Amazon EKS

```css
The goal is to prepare my EKS cluster to securely fetch secrets from AWS Secrets Manager using Pod Identity.

I’ll install the Secrets Store CSI Driver and the AWS Secrets and Configuration Provider (ASCP) on our EKS cluster. 

This setup enables Kubernetes Pods to securely retrieve secrets from AWS Secrets Manager 
and AWS Systems Manager Parameter Store, using EKS Pod Identity for authentication without 
storing any credentials inside the cluster.
```
## Install Helm CLI

> Helm CLI installation

```PowerShell
choco install kubernetes-helm
Chocolatey v2.4.2
Installing the following packages:
kubernetes-helm
By installing, you accept licenses for the packages.
Downloading package from source 'https://community.chocolatey.org/api/v2/'
Progress: Downloading kubernetes-helm 4.1.4... 100%

kubernetes-helm v4.1.4 [Approved]
kubernetes-helm package files install completed. Performing other installation steps.
The package kubernetes-helm wants to run 'chocolateyInstall.ps1'.
Note: If you don't run this script, the installation will fail.
Note: To confirm automatically next time, use '-y' or consider:
choco feature enable -n allowGlobalConfirmation
Do you want to run the script?([Y]es/[A]ll - yes to all/[N]o/[P]rint): Y

Downloading kubernetes-helm 64 bit
  from 'https://get.helm.sh/helm-v4.1.4-windows-amd64.zip'
Progress: 100% - Completed download of C:\Users\tchat\AppData\Local\Temp\chocolatey\kubernetes-helm\4.1.4\helm-v4.1.4-windows-amd64.zip (18.9 MB).
Download of helm-v4.1.4-windows-amd64.zip (18.9 MB) completed.
Hashes match.
Extracting C:\Users\tchat\AppData\Local\Temp\chocolatey\kubernetes-helm\4.1.4\helm-v4.1.4-windows-amd64.zip to C:\ProgramData\chocolatey\lib\kubernetes-helm\tools...
C:\ProgramData\chocolatey\lib\kubernetes-helm\tools
 ShimGen has successfully created a shim for helm.exe
 The install of kubernetes-helm was successful.
  Deployed to 'C:\ProgramData\chocolatey\lib\kubernetes-helm\tools'

Chocolatey installed 1/1 packages.
 See the log for details (C:\ProgramData\chocolatey\logs\chocolatey.log).

# -----------------------------------------------------------------------------------------------------
helm version
version.BuildInfo{Version:"v4.1.4", GitCommit:"05fa37973dc9e42b76e1d2883494c87174b6074f", GitTreeState:"clean", GoVersion:"go1.25.9", KubeClientVersion:"v1.35"}
```

> Add Helm Repositories

```PowerShell
# Add Helm Repositories
helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
"secrets-store-csi-driver" has been added to your repositories

# -----------------------------------------------------------------------------------------------------
helm repo add aws-secrets-manager https://aws.github.io/secrets-store-csi-driver-provider-aws
"aws-secrets-manager" has been added to your repositories

# -----------------------------------------------------------------------------------------------------
helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "aws-secrets-manager" chart repository
...Successfully got an update from the "secrets-store-csi-driver" chart repository
Update Complete. ⎈Happy Helming!⎈

# -----------------------------------------------------------------------------------------------------
# List Helm Repos
helm repo list
NAME                            URL
secrets-store-csi-driver        https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
aws-secrets-manager             https://aws.github.io/secrets-store-csi-driver-provider-aws
```

## Install the Secrets Store CSI Driver 

> Install the core driver that enables Kubernetes to mount external secrets.

```sh
# Install the Secrets Store CSI Driver in the kube-system namespace:
helm install csi-secrets-store \
  secrets-store-csi-driver/secrets-store-csi-driver \
  --namespace kube-system \
  --set tokenRequests[0].audience="pods.eks.amazonaws.com"
# List all Helm releases across namespaces:
helm list --all-namespaces
# List releases only in the kube-system namespace:
helm list -n kube-system
# -----------------------------------------------------------------------------------------------------
# Verify installation status, pods, and resources created by the release:
helm status csi-secrets-store -n kube-system
# -----------------------------------------------------------------------------------------------------
# Verify pods:
kubectl get pods -n kube-system -l app=secrets-store-csi-driver
```

```sh
helm list --all-namespaces
NAME    NAMESPACE       REVISION        UPDATED STATUS  CHART   APP VERSION
# -----------------------------------------------------------------------------------------------------
helm install csi-secrets-store \
  secrets-store-csi-driver/secrets-store-csi-driver \
  --namespace kube-system \
  --set tokenRequests[0].audience="pods.eks.amazonaws.com"
NAME: csi-secrets-store
LAST DEPLOYED: Thu Jun 11 16:57:33 2026
NAMESPACE: kube-system
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
TEST SUITE: None
NOTES:
The Secrets Store CSI Driver is getting deployed to your cluster.

To verify that Secrets Store CSI Driver has started, run:

  kubectl --namespace=kube-system get pods -l "app=secrets-store-csi-driver"

Now you can follow these steps https://secrets-store-csi-driver.sigs.k8s.io/getting-started/usage.html
to create a SecretProviderClass resource, and a deployment using the SecretProviderClass.

# -----------------------------------------------------------------------------------------------------
helm list --all-namespaces
NAME                    NAMESPACE       REVISION        UPDATED                                 STATUS        CHART                            APP VERSION
csi-secrets-store       kube-system     1               2026-06-11 16:57:33.3575051 -0400 EDT   deployed      secrets-store-csi-driver-1.6.0   1.6.0

# -----------------------------------------------------------------------------------------------------
kubectl --namespace=kube-system get pods -l "app=secrets-store-csi-driver"
NAME                                               READY   STATUS    RESTARTS   AGE
csi-secrets-store-secrets-store-csi-driver-p5lm7   3/3     Running   0          13m
csi-secrets-store-secrets-store-csi-driver-wch5s   3/3     Running   0          13m

# -----------------------------------------------------------------------------------------------------
helm list -n kube-system
NAME                    NAMESPACE       REVISION        UPDATED                                 STATUS        CHART                            APP VERSION
csi-secrets-store       kube-system     1               2026-06-11 16:57:33.3575051 -0400 EDT   deployed      secrets-store-csi-driver-1.6.0   1.6.0


# -----------------------------------------------------------------------------------------------------
helm status csi-secrets-store -n kube-system
NAME: csi-secrets-store
LAST DEPLOYED: Thu Jun 11 16:57:33 2026
NAMESPACE: kube-system
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
RESOURCES:
==> v1/ServiceAccount
NAME                       SECRETS   AGE
secrets-store-csi-driver   0         16m

==> v1/ClusterRole
NAME                               CREATED AT
secretproviderclasses-admin-role   2026-06-11T20:57:42Z
secretproviderclasses-viewer-role   2026-06-11T20:57:42Z
secretproviderclasspodstatuses-viewer-role   2026-06-11T20:57:42Z
secretproviderclasses-role   2026-06-11T20:57:42Z

==> v1/ClusterRoleBinding
NAME                                ROLE                                     AGE
secretproviderclasses-rolebinding   ClusterRole/secretproviderclasses-role   16m

==> v1/DaemonSet
NAME                                         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
csi-secrets-store-secrets-store-csi-driver   2         2         2       2            2           kubernetes.io/os=linux   16m

==> v1/Pod(related)
NAME                                               READY   STATUS    RESTARTS   AGE
csi-secrets-store-secrets-store-csi-driver-p5lm7   3/3     Running   0          16m
csi-secrets-store-secrets-store-csi-driver-wch5s   3/3     Running   0          16m

==> v1/CSIDriver
NAME                       ATTACHREQUIRED   PODINFOONMOUNT   STORAGECAPACITY   TOKENREQUESTS            REQUIRESREPUBLISH   MODES       AGE
secrets-store.csi.k8s.io   false            true             false             pods.eks.amazonaws.com   false               Ephemeral   16m


TEST SUITE: None
NOTES:
The Secrets Store CSI Driver is getting deployed to your cluster.

To verify that Secrets Store CSI Driver has started, run:

  kubectl --namespace=kube-system get pods -l "app=secrets-store-csi-driver"

Now you can follow these steps https://secrets-store-csi-driver.sigs.k8s.io/getting-started/usage.html
to create a SecretProviderClass resource, and a deployment using the SecretProviderClass.

# -----------------------------------------------------------------------------------------------------
kubectl get pods -n kube-system -l app=secrets-store-csi-driver
NAME                                               READY   STATUS    RESTARTS   AGE
csi-secrets-store-secrets-store-csi-driver-p5lm7   3/3     Running   0          18m
csi-secrets-store-secrets-store-csi-driver-wch5s   3/3     Running   0          18m

# -----------------------------------------------------------------------------------------------------
 kubectl get ds -n kube-system
NAME                                         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
aws-node                                     2         2         2       2            2           <none>                   8h
csi-secrets-store-secrets-store-csi-driver   2         2         2       2            2           kubernetes.io/os=linux   19m
eks-pod-identity-agent                       2         2         2       2            2           <none>                   6h54m

# -----------------------------------------------------------------------------------------------------
kubectl get nodes -o wide
NAME                                           STATUS   ROLES    AGE   VERSION               INTERNAL-IP      EXTERNAL-IP   OS-IMAGE                        KERNEL-VERSION                    CONTAINER-RUNTIME
ip-192-168-11-235.us-east-2.compute.internal   Ready    <none>   8h    v1.34.8-eks-3385e9b   192.168.11.235   <none>        Amazon Linux 2023.11.20260526   6.12.88-119.157.amzn2023.x86_64   containerd://2.2.3+unknown
ip-192-168-12-230.us-east-2.compute.internal   Ready    <none>   8h    v1.34.8-eks-3385e9b   192.168.12.230   <none>        Amazon Linux 2023.11.20260526   6.12.88-119.157.amzn2023.x86_64   containerd://2.2.3+unknown

# -----------------------------------------------------------------------------------------------------
kubectl get pods -n kube-system -l app=secrets-store-csi-driver -o wide
NAME                                               READY   STATUS    RESTARTS   AGE   IP               NODE                                           NOMINATED NODE   READINESS GATES
csi-secrets-store-secrets-store-csi-driver-p5lm7   3/3     Running   0          22m   192.168.11.199   ip-192-168-11-235.us-east-2.compute.internal   <none>           <none>
csi-secrets-store-secrets-store-csi-driver-wch5s   3/3     Running   0          22m   192.168.12.8     ip-192-168-12-230.us-east-2.compute.internal   <none>           <none>
```
At this point, the CSI driver is installed and working.


## Install the AWS Secrets and Configuration Provider (ASCP)

Install the AWS-specific provider that connects the CSI driver to AWS Secrets Manager and Parameter Store.

This component is called AWS Secrets and Configuration Provider (ASCP)

### Why --set secrets-store-csi-driver.install=false?

The AWS Provider Helm chart includes the CSI driver as a dependency by default. 
Since I already installed it previously, I must disable that dependency to prevent Helm ownership conflicts.

## Install the AWS Provider

```sh
# Install the AWS Secrets Manager CSI Driver Provider in the kube-system namespace.
helm install secrets-provider-aws \
  aws-secrets-manager/secrets-store-csi-driver-provider-aws \
  --namespace kube-system \
  --set secrets-store-csi-driver.install=false
# -----------------------------------------------------------------------------------------------------
# List installed Helm Releases
helm list -n kube-system
# -----------------------------------------------------------------------------------------------------
# Inspect the AWS provider Helm release:
helm status secrets-provider-aws -n kube-system
# -----------------------------------------------------------------------------------------------------
```


```sh
# Install the AWS Secrets Manager CSI Driver Provider in the kube-system namespace.
helm install secrets-provider-aws \
  aws-secrets-manager/secrets-store-csi-driver-provider-aws \
  --namespace kube-system \
  --set secrets-store-csi-driver.install=false
NAME: secrets-provider-aws
LAST DEPLOYED: Thu Jun 11 17:31:25 2026
NAMESPACE: kube-system
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
TEST SUITE: None

# -----------------------------------------------------------------------------------------------------
# List installed Helm Releases
helm list -n kube-system
NAME                    NAMESPACE       REVISION        UPDATED                                 STATUS        CHART                                            APP VERSION
csi-secrets-store       kube-system     1               2026-06-11 16:57:33.3575051 -0400 EDT   deployed      secrets-store-csi-driver-1.6.0                   1.6.0
secrets-provider-aws    kube-system     1               2026-06-11 17:31:25.7329063 -0400 EDT   deployed      secrets-store-csi-driver-provider-aws-3.1.1

# -----------------------------------------------------------------------------------------------------
# Inspect the AWS provider Helm release:
helm status secrets-provider-aws -n kube-system
NAME: secrets-provider-aws
LAST DEPLOYED: Thu Jun 11 17:31:25 2026
NAMESPACE: kube-system
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
RESOURCES:
==> v1/ServiceAccount
NAME                                                         SECRETS   AGE
secrets-provider-aws-secrets-store-csi-driver-provider-aws   0         3m4s

==> v1/ClusterRole
NAME                                                                      CREATED AT
secrets-provider-aws-secrets-store-csi-driver-provider-aws-cluster-role   2026-06-11T21:31:27Z

==> v1/ClusterRoleBinding
NAME                                                                              ROLE
                                                         AGE
secrets-provider-aws-secrets-store-csi-driver-provider-aws-cluster-role-binding   ClusterRole/secrets-provider-aws-secrets-store-csi-driver-provider-aws-cluster-role   3m4s

==> v1/DaemonSet
NAME                                                         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
secrets-provider-aws-secrets-store-csi-driver-provider-aws   2         2         2       2            2           kubernetes.io/os=linux   3m4s

==> v1/Pod(related)
NAME                                                              READY   STATUS    RESTARTS   AGE
secrets-provider-aws-secrets-store-csi-driver-provider-aws6vjvl   1/1     Running   0          3m4s
secrets-provider-aws-secrets-store-csi-driver-provider-awsv9qvk   1/1     Running   0          3m4s


TEST SUITE: None
```

- This command installs only the AWS provider (ASCP) components and reuses the CSI driver already installed.



```sh
# -----------------------------------------------------------------------------------------------------
helm list -n kube-system
NAME                    NAMESPACE       REVISION        UPDATED                                 STATUS        CHART                                            APP VERSION
csi-secrets-store       kube-system     1               2026-06-11 16:57:33.3575051 -0400 EDT   deployed      secrets-store-csi-driver-1.6.0                   1.6.0
secrets-provider-aws    kube-system     1               2026-06-11 17:31:25.7329063 -0400 EDT   deployed      secrets-store-csi-driver-provider-aws-3.1.1

# -----------------------------------------------------------------------------------------------------
kubectl get ds -n kube-system
NAME                                                         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
aws-node                                                     2         2         2       2            2           <none>                   8h
csi-secrets-store-secrets-store-csi-driver                   2         2         2       2            2           kubernetes.io/os=linux   47m
eks-pod-identity-agent                                       2         2         2       2            2           <none>                   7h22m
secrets-provider-aws-secrets-store-csi-driver-provider-aws   2         2         2       2            2           kubernetes.io/os=linux   13m
```

## Optional Flags

- *Purpose*: Use AWS FIPS endpoint (for compliance).
    - Flags: --set useFipsEndpoint=true
- *Purpose*: Tune API rate limits.
    - Flags: --set-json 'k8sThrottlingParams={"qps": "20", "burst": "40"}'
- *Purpose*: Adjust Pod Identity connection timeout.
    - Flags: --set podIdentityHttpTimeout=500ms

## Verify DaemonSets
```
kubectl get daemonset -n kube-system | grep secrets-store
csi-secrets-store-secrets-store-csi-driver                   2         2         2       2            2           kubernetes.io/os=linux   76m
secrets-provider-aws-secrets-store-csi-driver-provider-aws   2         2         2       2            2           kubernetes.io/os=linux   42m
```

## Troubleshooting

If I don’t see the AWS provider pods (csi-secrets-store-provider-aws):


```sh
kubectl describe daemonset secrets-provider-aws-secrets-store-csi-driver-provider-aws -n kube-system
kubectl logs -n kube-system -l app=secrets-store-csi-driver-provider-aws
```

```sh
kubectl describe daemonset secrets-provider-aws-secrets-store-csi-driver-provider-aws -n kube-system
Name:           secrets-provider-aws-secrets-store-csi-driver-provider-aws
Selector:       app=secrets-store-csi-driver-provider-aws
Node-Selector:  kubernetes.io/os=linux
Labels:         app=secrets-store-csi-driver-provider-aws
                app.kubernetes.io/instance=secrets-provider-aws
                app.kubernetes.io/managed-by=Helm
                app.kubernetes.io/name=secrets-store-csi-driver-provider-aws
                helm.sh/chart=secrets-store-csi-driver-provider-aws-3.1.1
Annotations:    deprecated.daemonset.template.generation: 1
                meta.helm.sh/release-name: secrets-provider-aws
                meta.helm.sh/release-namespace: kube-system
Desired Number of Nodes Scheduled: 2
Current Number of Nodes Scheduled: 2
Number of Nodes Scheduled with Up-to-date Pods: 2
Number of Nodes Scheduled with Available Pods: 2
Number of Nodes Misscheduled: 0
Pods Status:  2 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:           app=secrets-store-csi-driver-provider-aws
                    app.kubernetes.io/instance=secrets-provider-aws
                    app.kubernetes.io/managed-by=Helm
                    app.kubernetes.io/name=secrets-store-csi-driver-provider-aws
                    helm.sh/chart=secrets-store-csi-driver-provider-aws-3.1.1
  Service Account:  secrets-provider-aws-secrets-store-csi-driver-provider-aws
  Containers:
   provider-aws-installer:
    Image:      public.ecr.aws/aws-secrets-manager/secrets-store-csi-driver-provider-aws:3.1.1
    Port:       <none>
    Host Port:  <none>
    Args:
      --provider-volume=/var/run/secrets-store-csi-providers
    Limits:
      cpu:     50m
      memory:  100Mi
    Requests:
      cpu:        50m
      memory:     100Mi
    Environment:  <none>
    Mounts:
      /var/lib/kubelet/pods from mountpoint-dir (rw)
      /var/run/secrets-store-csi-providers from providervol (rw)
  Volumes:
   providervol:
    Type:          HostPath (bare host directory volume)
    Path:          /var/run/secrets-store-csi-providers
    HostPathType:
   mountpoint-dir:
    Type:          HostPath (bare host directory volume)
    Path:          /var/lib/kubelet/pods
    HostPathType:  DirectoryOrCreate
  Node-Selectors:  kubernetes.io/os=linux
  Tolerations:     <none>
Events:
  Type    Reason            Age   From                  Message
  ----    ------            ----  ----                  -------
  Normal  SuccessfulCreate  44m   daemonset-controller  Created pod: secrets-provider-aws-secrets-store-csi-driver-provider-awsv9qvk
  Normal  SuccessfulCreate  44m   daemonset-controller  Created pod: secrets-provider-aws-secrets-store-csi-driver-provider-aws6vjvl
# -----------------------------------------------------------------------------------------------------
```

## Optional: List All Resources Created by the AWS Provider

```sh
kubectl get all,sa,cm,ds,deploy,pod -n kube-system -l "app.kubernetes.io/instance=secrets-provider-aws"
NAME                                                                  READY   STATUS    RESTARTS   AGE
pod/secrets-provider-aws-secrets-store-csi-driver-provider-aws6vjvl   1/1     Running   0          59m
pod/secrets-provider-aws-secrets-store-csi-driver-provider-awsv9qvk   1/1     Running   0          59m

NAME                                                                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
daemonset.apps/secrets-provider-aws-secrets-store-csi-driver-provider-aws   2         2         2       2            2           kubernetes.io/os=linux   59m

NAME                                                                        SECRETS   AGE
serviceaccount/secrets-provider-aws-secrets-store-csi-driver-provider-aws   0         59m
```

## Create IAM Role, Policy and EKS Pod Identity Association

Now that the drivers are installed, let’s create IAM resources so Pods can securely assume an AWS role via Pod Identity.

## Create IAM Policy and Role for Pod Identity (AWS Secrets Manager Access)

In this step, i'll create a fine-grained IAM role and IAM policy that allow the MySQL Pod inside our EKS cluster 
to securely access credentials from AWS Secrets Manager, using EKS Pod Identity for authentication.

## Tasks:

- Export and verify key **AWS environment variables**.
- Create an **IAM policy** allowing Pods to read a specific **AWS secret**.
- Create an **IAM role** trusted by the **EKS Pod Identity Agent**.
- **Attach the policy** to the role.
- **Associate that IAM role** with the **Kubernetes ServiceAccount** (catalog-mysql-sa).
- Verify the **Pod Identity association**.

## Export Environment Variables

Before running any commands, export these values so everything works dynamically without edits later.

```sh
# Replace the placeholders below with your actual values
export AWS_REGION="us-east-2"
export EKS_CLUSTER_NAME="dev-ekslab"
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Confirm values
echo $AWS_REGION
echo $EKS_CLUSTER_NAME
echo $AWS_ACCOUNT_ID
# -----------------------------------------------------------------------------------------------------
echo $AWS_REGION
us-east-2

echo $EKS_CLUSTER_NAME
dev-ekslab

echo $AWS_ACCOUNT_ID
088356477647
# -----------------------------------------------------------------------------------------------------
```

