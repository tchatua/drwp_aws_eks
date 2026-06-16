# Terraform on AWS EKS Cluster with AddOns (LBC, EBS CSI, Secret Store CSI)

Here, I will build on top of my base EKS cluster from `b05_EKS_Cluster` and integrate `official AWS and Kubernetes add-ons` for `networking`, `storage`, `identity`, and `secret management`.

- AWS Load Balancer Controller (LBC) 
- Amazon EBS CSI Driver 
- Secrets Store CSI Driver (with ASCP) 
- EKS Pod Identity Agent

![alt text](image-3.png)

## Architecture Overview:

- This EKS architecture enhances my base EKS setup from `b05_EKS_Cluster` by integrating official AWS and Kubernetes add-ons that power modern workloads.

    - AddOn: Pod Identity Agent
    - Purpose: Enables Pods to assume IAM roles securely without storing credentials.

    - AddOn: AWS Load Balancer Controller (LBC)	
    - Purpose: Manages ALBs/NLBs for Ingress resources and Service type LoadBalancer.

    - AddOn: EBS CSI Driver	
    - Purpose: Enables dynamic provisioning of Amazon EBS volumes for Stateful workloads.

    - AddOn: Secrets Store CSI Driver + ASCP	
    - Purpose: Mounts AWS Secrets Manager / SSM Parameter Store secrets directly into Pods.


## Project Structure


```sh
# VPC
b04_VPC_Module/
|-- a01_01_Settings_Backend.tf
|-- a01_02_providers.tf
|-- a02_Global_Variables.tf
|-- a03_01_VPC.tf
|-- a03_02_VPC_Variables.tf
|-- a03_03_VPC_Outputs.tf
|-- b01_module
|   |-- README.md
|   `-- a01_vpc
|       |-- a01_Datasources.tf
|       |-- a02_02_VPC_Variables.tf
|       |-- a02_03_VPC_Locals.tf
|       |-- a02_04_VPC_Outputs.tf
|       |-- a03_Global_Variables.tf
|       |-- main.tf
|       `-- terraform.tfvars
`-- terraform.tfvars

# EKS Cluster
b05_EKS_Cluster
|-- a01_01_Settings_Backend.tf
|-- a01_02_providers.tf
|-- a02_01_Global_Variables.tf
|-- a02_02_Global_Locals.tf
|-- a03_01_Remote_State.tf
|-- a04_01_aws_ec2_tag.tf
|-- a05_EKS_IAM_Role.tf
|-- a06_02_EKS_Cluster_Variables.tf
|-- a07_eks_cluster.tf
|-- a08_EKS_Nodegroup_IAM_Role.tf
|-- a09_01_EKS_Nodegroup_Private.tf
|-- a09_02_EKS_Nodegroup_Private_Variables.tf
|-- a10_EKS_Outputs.tf
`-- terraform.tfvars

# EKS Cluster + Addons
|-- b01_01_data_eks_addon.tf
|-- b01_02_eks_addon.tf
|-- b01_03_eks_addon_outputs.tf
|-- b02_01_data_eks_cluster_auth.tf
|-- b02_02_helm_and_kubernetes_providers.tf
|-- b03_01_pod_identity_assume_role.tf
|-- b04_01_lbc_iam_policy_datasource.tf
|-- b04_02_lbc_iam_policy_datasource_output.tf
|-- b04_03_lbc_iam_policy_and_iam_role.tf
|-- b04_04_lbc_iam_policy_and_iam_role_outputs.tf
|-- b04_05_lbc_eks_pod_identity_association.tf
|-- b04_06_lbc_helm_install.tf
|-- 
|-- 
|-- 
|-- 
|-- 
|-- 
|-- 
|-- 
|-- 
|-- 
|-- 
|-- 
|-- 
|-- 
|-- 
`-- terraform.tfvars

```

```sh
 Error: reading EKS Add-On version info (south-jersey-eks-tchatua-dev-pod-identity-agent, 1.34): empty result
│
│   with data.aws_eks_addon_version.pia_default,
│   on b01_01_data_eks_addon.tf line 9, in data "aws_eks_addon_version" "pia_default":
│    9: data "aws_eks_addon_version" "pia_default" {
│
╵
╷
│ Error: reading EKS Add-On version info (south-jersey-eks-tchatua-dev-pod-identity-agent, 1.34): empty result
│
│   with data.aws_eks_addon_version.pia_latest,
│   on b01_01_data_eks_addon.tf line 19, in data "aws_eks_addon_version" "pia_latest":
│   19: data "aws_eks_addon_version" "pia_latest" {
│
╵
╷
│ Error: reading EKS Add-On version info (south-jersey-eks-tchatua-dev-aws-ebs-csi-driver, 1.34): empty result
│
│   with data.aws_eks_addon_version.ebs_csi_default,
│   on b05_03_ebs_csi_eks_addon.tf line 2, in data "aws_eks_addon_version" "ebs_csi_default":
│    2: data "aws_eks_addon_version" "ebs_csi_default" {
# ------------------------------------------------------------------------------------

terraform providers

Providers required by configuration:
.
├── provider[registry.terraform.io/hashicorp/aws] ~> 6.0
├── provider[terraform.io/builtin/terraform]
├── provider[registry.terraform.io/hashicorp/kubernetes] ~> 2.38.0
├── provider[registry.terraform.io/hashicorp/helm] ~> 3.1.0
└── provider[registry.terraform.io/hashicorp/http] ~> 3.5.0

Providers required by state:

    provider[registry.terraform.io/hashicorp/aws]

    provider[registry.terraform.io/hashicorp/http]

    provider[terraform.io/builtin/terraform]


# ------------------------------------------------------------------------------------

kubectl get pods
E0616 15:42:16.487152   30396 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"https://C86763260B8ADAC2FE760EA809866FA0.gr7.us-east-2.eks.amazonaws.com/api?timeout=32s\": dial tcp: lookup C86763260B8ADAC2FE760EA809866FA0.gr7.us-east-2.eks.amazonaws.com: no such host"
E0616 15:42:16.490377   30396 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"https://C86763260B8ADAC2FE760EA809866FA0.gr7.us-east-2.eks.amazonaws.com/api?timeout=32s\": dial tcp: lookup C86763260B8ADAC2FE760EA809866FA0.gr7.us-east-2.eks.amazonaws.com: no such host"
E0616 15:42:16.492461   30396 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"https://C86763260B8ADAC2FE760EA809866FA0.gr7.us-east-2.eks.amazonaws.com/api?timeout=32s\": dial tcp: lookup C86763260B8ADAC2FE760EA809866FA0.gr7.us-east-2.eks.amazonaws.com: no such host"
E0616 15:42:16.494651   30396 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"https://C86763260B8ADAC2FE760EA809866FA0.gr7.us-east-2.eks.amazonaws.com/api?timeout=32s\": dial tcp: lookup C86763260B8ADAC2FE760EA809866FA0.gr7.us-east-2.eks.amazonaws.com: no such host"
E0616 15:42:16.496297   30396 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"https://C86763260B8ADAC2FE760EA809866FA0.gr7.us-east-2.eks.amazonaws.com/api?timeout=32s\": dial tcp: lookup C86763260B8ADAC2FE760EA809866FA0.gr7.us-east-2.eks.amazonaws.com: no such host"
Unable to connect to the server: dial tcp: lookup C86763260B8ADAC2FE760EA809866FA0.gr7.us-east-2.eks.amazonaws.com: no such host
# ------------------------------------------------------------------------------------

aws eks update-kubeconfig \
  --name south-jersey-eks-tchatua-dev-eks-control-plane \
  --region us-east-2

# ------------------------------------------------------------------------------------

kubectl get pods
No resources found in default namespace.

kubectl get pods -n kube-system
NAME                                                              READY   STATUS    RESTARTS   AGE
aws-load-balancer-controller-6d95dd895-99594                      1/1     Running   0          23m
aws-load-balancer-controller-6d95dd895-k2w7g                      1/1     Running   0          23m
aws-node-fsr8q                                                    2/2     Running   0          3h11m
aws-node-wt659                                                    2/2     Running   0          3h11m
coredns-64ff95db9-fgs6d                                           1/1     Running   0          3h14m
coredns-64ff95db9-gg8pr                                           1/1     Running   0          3h14m
csi-secrets-store-secrets-store-csi-driver-25r5x                  3/3     Running   0          23m
csi-secrets-store-secrets-store-csi-driver-nwjmk                  3/3     Running   0          23m
ebs-csi-controller-6fc4855ddf-kq6x9                               6/6     Running   0          23m
ebs-csi-controller-6fc4855ddf-mh2cm                               6/6     Running   0          23m
ebs-csi-node-2q6xn                                                3/3     Running   0          23m
ebs-csi-node-pprlb                                                3/3     Running   0          23m
eks-pod-identity-agent-4bn9t                                      1/1     Running   0          24m
eks-pod-identity-agent-ztlkh                                      1/1     Running   0          24m
kube-proxy-bwmr4                                                  1/1     Running   0          3h11m
kube-proxy-z5dx7                                                  1/1     Running   0          3h11m
secrets-provider-aws-secrets-store-csi-driver-provider-awsjhfzm   1/1     Running   0          23m
secrets-provider-aws-secrets-store-csi-driver-provider-awstvsfh   1/1     Running   0          23m

# ------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------

```
