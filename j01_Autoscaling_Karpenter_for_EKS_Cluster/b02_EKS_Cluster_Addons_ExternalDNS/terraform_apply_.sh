terraform apply --auto-approve
data.terraform_remote_state.vpc: Reading...
data.http.lbc_iam_policy: Reading...
data.http.lbc_iam_policy: Read complete after 0s [id=https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json]
data.aws_iam_policy_document.assume_role: Reading...
aws_iam_policy.lbc_iam_policy: Refreshing state... [id=arn:aws:iam::088354478627:policy/south-jersey-eks-tchatua-dev-AWSLoadBalancerControllerIAMPolicy]
aws_iam_role.eks_cluster: Refreshing state... [id=south-jersey-eks-tchatua-dev-eks-cluster-role]
aws_iam_role.eks_nodegroup_role: Refreshing state... [id=south-jersey-eks-tchatua-dev-eks-nodegroup-role]
data.aws_iam_policy_document.assume_role: Read complete after 0s [id=819195744]
aws_iam_role.ebs_csi_iam_role: Refreshing state... [id=south-jersey-eks-tchatua-dev-ebs-csi-iam-role]
aws_iam_role.lbc_iam_role: Refreshing state... [id=south-jersey-eks-tchatua-dev-lbc-iam-role]
aws_iam_role_policy_attachment.lbc_iam_role_policy_attach: Refreshing state... [id=south-jersey-eks-tchatua-dev-lbc-iam-role/arn:aws:iam::088354478627:policy/south-jersey-eks-tchatua-dev-AWSLoadBalancerControllerIAMPolicy]
aws_iam_role_policy_attachment.eks_cluster_policy: Refreshing state... [id=south-jersey-eks-tchatua-dev-eks-cluster-role/arn:aws:iam::aws:policy/AmazonEKSClusterPolicy]
aws_iam_role_policy_attachment.eks_cni_policy: Refreshing state... [id=south-jersey-eks-tchatua-dev-eks-nodegroup-role/arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy]
aws_iam_role_policy_attachment.eks_ecr_policy: Refreshing state... [id=south-jersey-eks-tchatua-dev-eks-nodegroup-role/arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly]
aws_iam_role_policy_attachment.eks_worker_node_policy: Refreshing state... [id=south-jersey-eks-tchatua-dev-eks-nodegroup-role/arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy]
aws_iam_role_policy_attachment.eks_vpc_resource_controller: Refreshing state... [id=south-jersey-eks-tchatua-dev-eks-cluster-role/arn:aws:iam::aws:policy/AmazonEKSVPCResourceController]
aws_iam_role_policy_attachment.ebs_csi_managed_policy_attach: Refreshing state... [id=south-jersey-eks-tchatua-dev-ebs-csi-iam-role/arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy]
data.terraform_remote_state.vpc: Read complete after 1s
aws_ec2_tag.eks_subnet_tag_private_elb["subnet-007f9ae84a62067a8"]: Refreshing state... [id=subnet-007f9ae84a62067a8,kubernetes.io/role/internal-elb]
aws_ec2_tag.eks_subnet_tag_private_elb["subnet-0a9586975462bd50c"]: Refreshing state... [id=subnet-0a9586975462bd50c,kubernetes.io/role/internal-elb]
aws_ec2_tag.eks_subnet_tag_private_elb["subnet-07d564f6ad7bbae39"]: Refreshing state... [id=subnet-07d564f6ad7bbae39,kubernetes.io/role/internal-elb]
aws_ec2_tag.eks_subnet_tag_public_cluster["subnet-043c9a908d2151bf2"]: Refreshing state... [id=subnet-043c9a908d2151bf2,kubernetes.io/cluster/south-jersey-eks-tchatua-dev-drwpekscluster]
aws_ec2_tag.eks_subnet_tag_public_cluster["subnet-0ae4115b3f13aac11"]: Refreshing state... [id=subnet-0ae4115b3f13aac11,kubernetes.io/cluster/south-jersey-eks-tchatua-dev-drwpekscluster]
aws_ec2_tag.eks_subnet_tag_public_cluster["subnet-0b6e5f52b3052417a"]: Refreshing state... [id=subnet-0b6e5f52b3052417a,kubernetes.io/cluster/south-jersey-eks-tchatua-dev-drwpekscluster]
aws_ec2_tag.eks_subnet_tag_public_elb["subnet-0b6e5f52b3052417a"]: Refreshing state... [id=subnet-0b6e5f52b3052417a,kubernetes.io/role/elb]
aws_ec2_tag.eks_subnet_tag_public_elb["subnet-043c9a908d2151bf2"]: Refreshing state... [id=subnet-043c9a908d2151bf2,kubernetes.io/role/elb]
aws_ec2_tag.eks_subnet_tag_public_elb["subnet-0ae4115b3f13aac11"]: Refreshing state... [id=subnet-0ae4115b3f13aac11,kubernetes.io/role/elb]
aws_ec2_tag.eks_subnet_tag_private_cluster["subnet-0a9586975462bd50c"]: Refreshing state... [id=subnet-0a9586975462bd50c,kubernetes.io/cluster/south-jersey-eks-tchatua-dev-drwpekscluster]
aws_ec2_tag.eks_subnet_tag_private_cluster["subnet-07d564f6ad7bbae39"]: Refreshing state... [id=subnet-07d564f6ad7bbae39,kubernetes.io/cluster/south-jersey-eks-tchatua-dev-drwpekscluster]
aws_ec2_tag.eks_subnet_tag_private_cluster["subnet-007f9ae84a62067a8"]: Refreshing state... [id=subnet-007f9ae84a62067a8,kubernetes.io/cluster/south-jersey-eks-tchatua-dev-drwpekscluster]
aws_eks_cluster.eks_control_plane: Refreshing state... [id=south-jersey-eks-tchatua-dev-eks-control-plane]
aws_eks_node_group.eks_node_group: Refreshing state... [id=south-jersey-eks-tchatua-dev-eks-control-plane:south-jersey-eks-tchatua-dev-eks-control-plane-eks-node-group]
data.aws_eks_addon_version.pia_default: Reading...
aws_eks_pod_identity_association.lbc: Refreshing state... [id=a-p2d7z8b7cu1t06cw8]
data.aws_eks_cluster_auth.eks_cluster_auth: Reading...
data.aws_eks_addon_version.ebs_csi_latest: Reading...
data.aws_eks_addon_version.pia_latest: Reading...
aws_eks_pod_identity_association.ebs_csi: Refreshing state... [id=a-c1xlqajhy3u2ojrli]
data.aws_eks_addon_version.ebs_csi_default: Reading...
data.aws_eks_cluster_auth.eks_cluster_auth: Read complete after 0s [id=south-jersey-eks-tchatua-dev-eks-control-plane]
data.aws_eks_addon_version.pia_default: Read complete after 0s [id=eks-pod-identity-agent]
data.aws_eks_addon_version.pia_latest: Read complete after 0s [id=eks-pod-identity-agent]
data.aws_eks_addon_version.ebs_csi_default: Read complete after 0s [id=aws-ebs-csi-driver]
data.aws_eks_addon_version.ebs_csi_latest: Read complete after 0s [id=aws-ebs-csi-driver]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create
# -------------------------------------------------------------
Terraform will perform the following actions:

  # aws_eks_addon.ebs_csi will be created
  + resource "aws_eks_addon" "ebs_csi" {
      + addon_name                  = "aws-ebs-csi-driver"
      + addon_version               = "v1.61.1-eksbuild.1"
      + arn                         = (known after apply)
      + cluster_name                = "south-jersey-eks-tchatua-dev-eks-control-plane"
      + configuration_values        = (known after apply)
      + created_at                  = (known after apply)
      + id                          = (known after apply)
      + modified_at                 = (known after apply)
      + region                      = "us-east-2"
      + resolve_conflicts_on_create = "OVERWRITE"
      + resolve_conflicts_on_update = "OVERWRITE"
      + service_account_role_arn    = "arn:aws:iam::088354478627:role/south-jersey-eks-tchatua-dev-ebs-csi-iam-role"
      + tags                        = {
          + "Component"   = "Amazon EBS CSI Driver"
          + "Environment" = "dev"
          + "Name"        = "south-jersey-eks-tchatua-dev--aws-ebs-csi-addon"
        }
      + tags_all                    = {
          + "Component"   = "Amazon EBS CSI Driver"
          + "Environment" = "dev"
          + "Name"        = "south-jersey-eks-tchatua-dev--aws-ebs-csi-addon"
        }

      + namespace_config (known after apply)
    }
# -------------------------------------------------------------
  # aws_eks_addon.pod_identity will be created
  + resource "aws_eks_addon" "pod_identity" {
      + addon_name                  = "eks-pod-identity-agent"
      + addon_version               = "v1.3.10-eksbuild.3"
      + arn                         = (known after apply)
      + cluster_name                = "south-jersey-eks-tchatua-dev-eks-control-plane"
      + configuration_values        = (known after apply)
      + created_at                  = (known after apply)
      + id                          = (known after apply)
      + modified_at                 = (known after apply)
      + region                      = "us-east-2"
      + resolve_conflicts_on_create = "OVERWRITE"
      + resolve_conflicts_on_update = "OVERWRITE"
      + tags_all                    = (known after apply)

      + namespace_config (known after apply)
    }
# -------------------------------------------------------------
  # helm_release.aws_secrets_provider will be created
  + resource "helm_release" "aws_secrets_provider" {
      + atomic                     = false
      + chart                      = "secrets-store-csi-driver-provider-aws"
      + cleanup_on_fail            = true
      + create_namespace           = false
      + dependency_update          = false
      + disable_crd_hooks          = false
      + disable_openapi_validation = false
      + disable_webhooks           = false
      + force_update               = false
      + id                         = (known after apply)
      + lint                       = false
      + max_history                = 0
      + metadata                   = (known after apply)
      + name                       = "secrets-provider-aws"
      + namespace                  = "kube-system"
      + pass_credentials           = false
      + recreate_pods              = false
      + render_subchart_notes      = true
      + replace                    = false
      + repository                 = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
      + reset_values               = false
      + reuse_values               = false
      + set                        = [
          + {
              + name  = "secrets-store-csi-driver.install"
              + value = "false"
                # (1 unchanged attribute hidden)
            },
        ]
      + set_wo                     = (write-only attribute)
      + skip_crds                  = false
      + status                     = "deployed"
      + take_ownership             = false
      + timeout                    = 600
      + upgrade_install            = false
      + verify                     = false
      + version                    = "3.1.1"
      + wait                       = true
      + wait_for_jobs              = false
    }

  # helm_release.loadbalancer_controller will be created
  + resource "helm_release" "loadbalancer_controller" {
      + atomic                     = false
      + chart                      = "aws-load-balancer-controller"
      + cleanup_on_fail            = true
      + create_namespace           = false
      + dependency_update          = false
      + disable_crd_hooks          = false
      + disable_openapi_validation = false
      + disable_webhooks           = false
      + force_update               = false
      + id                         = (known after apply)
      + lint                       = false
      + max_history                = 0
      + metadata                   = (known after apply)
      + name                       = "aws-load-balancer-controller"
      + namespace                  = "kube-system"
      + pass_credentials           = false
      + recreate_pods              = false
      + render_subchart_notes      = true
      + replace                    = false
      + repository                 = "https://aws.github.io/eks-charts"
      + reset_values               = false
      + reuse_values               = false
      + set                        = [
          + {
              + name  = "serviceAccount.create"
              + value = "true"
                # (1 unchanged attribute hidden)
            },
          + {
              + name  = "serviceAccount.name"
              + value = "aws-load-balancer-controller"
                # (1 unchanged attribute hidden)
            },
          + {
              + name  = "clusterName"
              + value = "south-jersey-eks-tchatua-dev-eks-control-plane"
                # (1 unchanged attribute hidden)
            },
          + {
              + name  = "vpcId"
              + value = "vpc-02278feb165395a9e"
                # (1 unchanged attribute hidden)
            },
          + {
              + name  = "region"
              + value = "us-east-2"
                # (1 unchanged attribute hidden)
            },
        ]
      + set_wo                     = (write-only attribute)
      + skip_crds                  = false
      + status                     = "deployed"
      + take_ownership             = false
      + timeout                    = 600
      + upgrade_install            = false
      + verify                     = false
      + version                    = "3.4.0"
      + wait                       = true
      + wait_for_jobs              = false
    }

  # helm_release.secrets_store_csi_driver will be created
  + resource "helm_release" "secrets_store_csi_driver" {
      + atomic                     = false
      + chart                      = "secrets-store-csi-driver"
      + cleanup_on_fail            = true
      + create_namespace           = false
      + dependency_update          = false
      + disable_crd_hooks          = false
      + disable_openapi_validation = false
      + disable_webhooks           = false
      + force_update               = false
      + id                         = (known after apply)
      + lint                       = false
      + max_history                = 0
      + metadata                   = (known after apply)
      + name                       = "csi-secrets-store"
      + namespace                  = "kube-system"
      + pass_credentials           = false
      + recreate_pods              = false
      + render_subchart_notes      = true
      + replace                    = false
      + repository                 = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
      + reset_values               = false
      + reuse_values               = false
      + set                        = [
          + {
              + name  = "syncSecret.enabled"
              + value = "true"
                # (1 unchanged attribute hidden)
            },
        ]
      + set_wo                     = (write-only attribute)
      + skip_crds                  = false
      + status                     = "deployed"
      + take_ownership             = false
      + timeout                    = 600
      + upgrade_install            = false
      + verify                     = false
      + version                    = "1.6.0"
      + wait                       = true
      + wait_for_jobs              = false
    }

Plan: 5 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + ebs_csi_addon_arn                            = (known after apply)
  + ebs_csi_addon_default_version                = "v1.61.1-eksbuild.1"
  + ebs_csi_addon_id                             = (known after apply)
  + helm_aws_secrets_provider_metadata           = (known after apply)
  + helm_lbc_metadata                            = (known after apply)
  + helm_secrets_store_csi_driver_metadata       = (known after apply)
  + pod_identity_agent_eks_addon_arn             = (known after apply)
  + pod_identity_agent_eks_addon_default_version = {
      + addon_name         = "eks-pod-identity-agent"
      + id                 = "eks-pod-identity-agent"
      + kubernetes_version = "1.34"
      + most_recent        = false
      + region             = "us-east-2"
      + version            = "v1.3.10-eksbuild.3"
    }
  + pod_identity_agent_eks_addon_id              = (known after apply)
  + pod_identity_agent_eks_addon_latest_version  = {
      + addon_name         = "eks-pod-identity-agent"
      + id                 = "eks-pod-identity-agent"
      + kubernetes_version = "1.34"
      + most_recent        = true
      + region             = "us-east-2"
      + version            = "v1.3.10-eksbuild.3"
    }
aws_eks_addon.pod_identity: Creating...
aws_eks_addon.pod_identity: Still creating... [00m10s elapsed]
aws_eks_addon.pod_identity: Still creating... [00m20s elapsed]
aws_eks_addon.pod_identity: Creation complete after 24s [id=south-jersey-eks-tchatua-dev-eks-control-plane:eks-pod-identity-agent]
aws_eks_addon.ebs_csi: Creating...
helm_release.secrets_store_csi_driver: Creating...
helm_release.loadbalancer_controller: Creating...
aws_eks_addon.ebs_csi: Still creating... [00m10s elapsed]
helm_release.secrets_store_csi_driver: Still creating... [00m10s elapsed]
helm_release.loadbalancer_controller: Still creating... [00m10s elapsed]
aws_eks_addon.ebs_csi: Still creating... [00m20s elapsed]
helm_release.secrets_store_csi_driver: Still creating... [00m20s elapsed]
helm_release.loadbalancer_controller: Still creating... [00m20s elapsed]
helm_release.secrets_store_csi_driver: Creation complete after 23s [id=csi-secrets-store]
helm_release.aws_secrets_provider: Creating...
helm_release.loadbalancer_controller: Creation complete after 23s [id=aws-load-balancer-controller]
helm_release.aws_secrets_provider: Creation complete after 6s [id=secrets-provider-aws]
aws_eks_addon.ebs_csi: Still creating... [00m30s elapsed]
aws_eks_addon.ebs_csi: Creation complete after 35s [id=south-jersey-eks-tchatua-dev-eks-control-plane:aws-ebs-csi-driver]
╷
│ Warning: Deprecated Parameter
│
│   with data.terraform_remote_state.vpc,
│   on a03_01_Remote_State.tf line 1, in data "terraform_remote_state" "vpc":
│    1: data "terraform_remote_state" "vpc" {
│
│ The parameter "dynamodb_table" is deprecated. Use parameter "use_lockfile" instead.
│
│ (and 2 more similar warnings elsewhere)
╵

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

ebs_csi_addon_arn = "arn:aws:eks:us-east-2:088354478627:addon/south-jersey-eks-tchatua-dev-eks-control-plane/aws-ebs-csi-driver/e0cf68f1-2649-cd8b-26d3-586fd219f65b"
ebs_csi_addon_default_version = "v1.61.1-eksbuild.1"
ebs_csi_addon_id = "south-jersey-eks-tchatua-dev-eks-control-plane:aws-ebs-csi-driver"
ebs_csi_addon_latest_version = "v1.61.1-eksbuild.1"
ebs_csi_iam_role_arn = "arn:aws:iam::088354478627:role/south-jersey-eks-tchatua-dev-ebs-csi-iam-role"
ebs_csi_pod_identity_association_arn = "arn:aws:eks:us-east-2:088354478627:podidentityassociation/south-jersey-eks-tchatua-dev-eks-control-plane/a-c1xlqajhy3u2ojrli"
eks_cluster_arn = "arn:aws:eks:us-east-2:088354478627:cluster/south-jersey-eks-tchatua-dev-eks-control-plane"
eks_cluster_certificate_authority_data = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJRGh0Umo4OUQ5eFF3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TmpBMk1UWXhOakkxTkROYUZ3MHpOakEyTVRNeE5qTXdORE5hTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUUM0VEpKRWtQcEpNTTBQditFN3lpbG85ZkF3WXN3MXlSOFhvZm9nS0VtQnhRUTA1SkpmYlZLZ0hKR1cKdkp1QzNkb1hIQVZXQTMzckhFd2VCcUVDNGhKMHZqb1Z5U3MvYjlsUVkraG9Pc1IrZ2h3S3FZc3ByY2RZSHJGQQpNTjRtbG9tMytlMFptZnAyb2g2SmZUQlYydGRxRmpBdktGL3BiQlhyK281bW5nWHRqdjVZSThqT0h6b0tjVlpXClo3YXNpK1RDVnU3eVFhTjF2N1N1c0U2NFl0UFluZVpMSUk2VG5xczBES1hXWTFZc1VOS21HbkZyaFJTNnpYUTkKZEJmREFuTlF1T1o0bzlmVXZibnhvenp0NkZWWHVEZGFSMjRURzBOU0FlR1dmb3RVMThoWThlaHViaiswSFJuWQpJZnJlcEU2OHRkUGJxRHB5SHUvcG5TUWlwc1ZKQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJUcGoweXVHMy9MYWlUQ3gwY3BXWUZIWkNOMDREQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ20rMDZRNWhCZApBVmlyZGM4UENTa1lqa3RONGNxMUxldnovVm9nMlRDM2g4a2ZsamtrTk5teDNkd0MwcnpOSGlOVCswVGI5clBECkdGUHkxdWhpNkppTmpiMUFybFU3bjZrSVVjM00xNzM5NG1Cc010MlEzUVUyM1VobGdTWWMyMytxMUxQeTNKYUsKQi94VjVLUS9uZmM4T2dJZTdiUXJCY0VaaFh5bEJLc01MNkRlZWtkWllUWElqbWc5N09WREIxV0dsbGhqV24wcwp4T2kxWGtGZy9FWHRqUlhyYm5hbkp3M2lYL2NvcndqbnZabkFaSFIvd0lqbjVhT29qNWdvYTRuc0VQN2ZmNjVNCmEvd1BGaEd2UkxINWRyL2ptRjZNWGVscSsya24ycEFremJlNXFvWHZlYXByRzh6WlA4aGk5ZUJxL3Ywa3NoTGUKUmVFcVh0RTFRY294Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"
eks_cluster_endpoint = "https://632184582D099BD07EA6DCA25FEE7370.gr7.us-east-2.eks.amazonaws.com"
eks_cluster_id = "south-jersey-eks-tchatua-dev-eks-control-plane"
eks_cluster_name = "south-jersey-eks-tchatua-dev-eks-control-plane"
eks_cluster_security_group_id = "sg-0ea854de090f37d72"
eks_cluster_status = "ACTIVE"
eks_cluster_version = "1.34"
eks_node_instance_role_arn = "arn:aws:iam::088354478627:role/south-jersey-eks-tchatua-dev-eks-nodegroup-role"
helm_aws_secrets_provider_metadata = {
  "app_version" = ""
  "chart" = "secrets-store-csi-driver-provider-aws"
  "first_deployed" = 1781637750
  "last_deployed" = 1781637750
  "name" = "secrets-provider-aws"
  "namespace" = "kube-system"
  "notes" = ""
  "revision" = 1
  "values" = "{\"secrets-store-csi-driver\":{\"install\":false}}"
  "version" = "3.1.1"
}
helm_lbc_metadata = {
  "app_version" = "v3.4.0"
  "chart" = "aws-load-balancer-controller"
  "first_deployed" = 1781637729
  "last_deployed" = 1781637729
  "name" = "aws-load-balancer-controller"
  "namespace" = "kube-system"
  "notes" = <<-EOT
  AWS Load Balancer controller installed!

  EOT
  "revision" = 1
  "values" = "{\"clusterName\":\"south-jersey-eks-tchatua-dev-eks-control-plane\",\"region\":\"us-east-2\",\"serviceAccount\":{\"create\":true,\"name\":\"aws-load-balancer-controller\"},\"vpcId\":\"vpc-02278feb165395a9e\"}"
  "version" = "3.4.0"
}
helm_secrets_store_csi_driver_metadata = {
  "app_version" = "1.6.0"
  "chart" = "secrets-store-csi-driver"
  "first_deployed" = 1781637728
  "last_deployed" = 1781637728
  "name" = "csi-secrets-store"
  "namespace" = "kube-system"
  "notes" = <<-EOT
  The Secrets Store CSI Driver is getting deployed to your cluster.

  To verify that Secrets Store CSI Driver has started, run:

    kubectl --namespace=kube-system get pods -l "app=secrets-store-csi-driver"

  Now you can follow these steps https://secrets-store-csi-driver.sigs.k8s.io/getting-started/usage.html
  to create a SecretProviderClass resource, and a deployment using the SecretProviderClass.

  EOT
  "revision" = 1
  "values" = "{\"syncSecret\":{\"enabled\":true}}"
  "version" = "1.6.0"
}
lbc_iam_policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": "elasticloadbalancing.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAddresses",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeVpcs",
                "ec2:DescribeVpcPeeringConnections",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeInstances",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeTags",
                "ec2:GetCoipPoolUsage",
                "ec2:DescribeCoipPools",
                "ec2:GetSecurityGroupsForVpc",
                "ec2:DescribeIpamPools",
                "ec2:DescribeRouteTables",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeListenerCertificates",
                "elasticloadbalancing:DescribeSSLPolicies",
                "elasticloadbalancing:DescribeRules",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTargetGroupAttributes",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:DescribeTrustStores",
                "elasticloadbalancing:DescribeListenerAttributes",
                "elasticloadbalancing:DescribeCapacityReservation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cognito-idp:DescribeUserPoolClient",
                "acm:ListCertificates",
                "acm:DescribeCertificate",
                "iam:ListServerCertificates",
                "iam:GetServerCertificate",
                "waf-regional:GetWebACL",
                "waf-regional:GetWebACLForResource",
                "waf-regional:AssociateWebACL",
                "waf-regional:DisassociateWebACL",
                "wafv2:GetWebACL",
                "wafv2:GetWebACLForResource",
                "wafv2:AssociateWebACL",
                "wafv2:DisassociateWebACL",
                "shield:GetSubscriptionState",
                "shield:DescribeProtection",
                "shield:CreateProtection",
                "shield:DeleteProtection"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:RevokeSecurityGroupIngress"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateSecurityGroup"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags"
            ],
            "Resource": "arn:aws:ec2:*:*:security-group/*",
            "Condition": {
                "StringEquals": {
                    "ec2:CreateAction": "CreateSecurityGroup"
                },
                "Null": {
                    "aws:RequestTag/elbv2.k8s.aws/cluster": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags",
                "ec2:DeleteTags"
            ],
            "Resource": "arn:aws:ec2:*:*:security-group/*",
            "Condition": {
                "Null": {
                    "aws:RequestTag/elbv2.k8s.aws/cluster": "true",
                    "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:DeleteSecurityGroup"
            ],
            "Resource": "*",
            "Condition": {
                "Null": {
                    "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:CreateLoadBalancer",
                "elasticloadbalancing:CreateTargetGroup"
            ],
            "Resource": "*",
            "Condition": {
                "Null": {
                    "aws:RequestTag/elbv2.k8s.aws/cluster": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:CreateListener",
                "elasticloadbalancing:DeleteListener",
                "elasticloadbalancing:CreateRule",
                "elasticloadbalancing:DeleteRule"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:RemoveTags"
            ],
            "Resource": [
                "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
                "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
                "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
            ],
            "Condition": {
                "Null": {
                    "aws:RequestTag/elbv2.k8s.aws/cluster": "true",
                    "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:RemoveTags"
            ],
            "Resource": [
                "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*",
                "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
                "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
                "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "elasticloadbalancing:SetIpAddressType",
                "elasticloadbalancing:SetSecurityGroups",
                "elasticloadbalancing:SetSubnets",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:ModifyTargetGroup",
                "elasticloadbalancing:ModifyTargetGroupAttributes",
                "elasticloadbalancing:DeleteTargetGroup",
                "elasticloadbalancing:ModifyListenerAttributes",
                "elasticloadbalancing:ModifyCapacityReservation",
                "elasticloadbalancing:ModifyIpPools"
            ],
            "Resource": "*",
            "Condition": {
                "Null": {
                    "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:AddTags"
            ],
            "Resource": [
                "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
                "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
                "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
            ],
            "Condition": {
                "StringEquals": {
                    "elasticloadbalancing:CreateAction": [
                        "CreateTargetGroup",
                        "CreateLoadBalancer"
                    ]
                },
                "Null": {
                    "aws:RequestTag/elbv2.k8s.aws/cluster": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:RegisterTargets",
                "elasticloadbalancing:DeregisterTargets"
            ],
            "Resource": "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:SetWebAcl",
                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:AddListenerCertificates",
                "elasticloadbalancing:RemoveListenerCertificates",
                "elasticloadbalancing:ModifyRule",
                "elasticloadbalancing:SetRulePriorities"
            ],
            "Resource": "*"
        }
    ]
}

EOT
lbc_iam_policy_arn = "arn:aws:iam::088354478627:policy/south-jersey-eks-tchatua-dev-AWSLoadBalancerControllerIAMPolicy"
lbc_iam_role_arn = "arn:aws:iam::088354478627:role/south-jersey-eks-tchatua-dev-lbc-iam-role"
lbc_pod_identity_association_arn = "arn:aws:eks:us-east-2:088354478627:podidentityassociation/south-jersey-eks-tchatua-dev-eks-control-plane/a-p2d7z8b7cu1t06cw8"
pod_identity_agent_eks_addon_arn = "arn:aws:eks:us-east-2:088354478627:addon/south-jersey-eks-tchatua-dev-eks-control-plane/eks-pod-identity-agent/b4cf68f0-f706-c802-60b1-157c253431b8"
pod_identity_agent_eks_addon_default_version = {
  "addon_name" = "eks-pod-identity-agent"
  "id" = "eks-pod-identity-agent"
  "kubernetes_version" = "1.34"
  "most_recent" = false
  "region" = "us-east-2"
  "version" = "v1.3.10-eksbuild.3"
}
pod_identity_agent_eks_addon_id = "south-jersey-eks-tchatua-dev-eks-control-plane:eks-pod-identity-agent"
pod_identity_agent_eks_addon_latest_version = {
  "addon_name" = "eks-pod-identity-agent"
  "id" = "eks-pod-identity-agent"
  "kubernetes_version" = "1.34"
  "most_recent" = true
  "region" = "us-east-2"
  "version" = "v1.3.10-eksbuild.3"
}
private_node_group_name = "south-jersey-eks-tchatua-dev-eks-control-plane-eks-node-group"
private_subnet_ids = [
  "subnet-07d564f6ad7bbae39",
  "subnet-007f9ae84a62067a8",
  "subnet-0a9586975462bd50c",
]
public_subnet_ids = [
  "subnet-0b6e5f52b3052417a",
  "subnet-043c9a908d2151bf2",
  "subnet-0ae4115b3f13aac11",
]
to_configure_kubectl_command = "aws eks --region us-east-2 update-kubeconfig --name south-jersey-eks-tchatua-dev-eks-control-plane"
vpc_id = "vpc-02278feb165395a9e"

