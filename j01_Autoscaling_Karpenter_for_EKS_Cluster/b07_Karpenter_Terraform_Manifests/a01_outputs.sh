Outputs:

account_id = "088354478627"
caller_arn = "arn:aws:iam::088354478627:user/terraform"
caller_user = "AIDARJESWLIRXGQLGHTXZ"
eks_cluster_id = "eks-control-plane"
eks_cluster_name = "eks-control-plane"
karpenter_controller_pod_identity_association = "a-jxbh2u5brqfqmhpa7"
karpenter_controller_role_arn = "arn:aws:iam::088354478627:role/drwp-dev-karpenter-controller-role"
karpenter_controller_role_name = "drwp-dev-karpenter-controller-role"
karpenter_helm_metadata = {
  "app_version" = "1.8.2"
  "chart" = "karpenter"
  "first_deployed" = 1783473570
  "last_deployed" = 1783473570
  "name" = "karpenter"
  "namespace" = "kube-system"
  "notes" = ""
  "revision" = 1
  "values" = "{\"serviceAccount\":{\"create\":true,\"name\":\"karpenter\"},\"settings\":{\"clusterEndpoint\":\"https://5865000538DA3CD8BA8376DBCDDADD24.gr7.us-east-2.eks.amazonaws.com\",\"clusterName\":\"eks-control-plane\",\"interruptionQueue\":\"eks-control-plane\"}}"
  "version" = "1.8.2"
}
karpenter_node_role_arn = "arn:aws:iam::088354478627:role/drwp-dev-karpenter-node-role"
karpenter_node_role_name = "drwp-dev-karpenter-node-role"
karpenter_node_role_unique_id = "AROARJESWLIR4BQTH3ERH"
private_subnet_ids = [
  "subnet-0739442a734c80426",
  "subnet-0a045721ae0be0436",
  "subnet-037489b0725fabe93",
]
public_subnet_ids = [
  "subnet-0c4b3fecc1d2e3a5a",
  "subnet-02634dfd14249af77",
  "subnet-02d05e7dd6c54c8e8",
]
vpc_id = "vpc-0e470907c96317802"
