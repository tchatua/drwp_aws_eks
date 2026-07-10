# Apply complete! Resources: 21 added, 0 changed, 0 destroyed.

# Outputs:

account_id = "088354478627"
caller_arn = "arn:aws:iam::088354478627:user/terraform"
caller_user = "AIDARJESWLIRXGQLGHTXZ"
eks_cluster_id = "eks-control-plane"
eks_cluster_name = "eks-control-plane"
karpenter_controller_pod_identity_association = "a-lxarvrkmrtawbjpv4"
karpenter_controller_role_arn = "arn:aws:iam::088354478627:role/drwp-dev-karpenter-controller-role"
karpenter_controller_role_name = "drwp-dev-karpenter-controller-role"
karpenter_helm_metadata = {
  "app_version" = "1.8.2"
  "chart" = "karpenter"
  "first_deployed" = 1783508861
  "last_deployed" = 1783508861
  "name" = "karpenter"
  "namespace" = "kube-system"
  "notes" = ""
  "revision" = 1
  "values" = "{\"serviceAccount\":{\"create\":true,\"name\":\"karpenter\"},\"settings\":{\"clusterEndpoint\":\"https://5865000538DA3CD8BA8376DBCDDADD24.gr7.us-east-2.eks.amazonaws.com\",\"clusterName\":\"eks-control-plane\",\"interruptionQueue\":\"eks-control-plane\"}}"
  "version" = "1.8.2"
}
karpenter_node_role_arn = "arn:aws:iam::088354478627:role/drwp-dev-karpenter-node-role"
karpenter_node_role_name = "drwp-dev-karpenter-node-role"
karpenter_node_role_unique_id = "AROARJESWLIRUYXKPAJQ2"
private_subnet_ids = [
  "subnet-0739442a734c80426",
  "subnet-0a045721ae0be0436",
  "subnet-037489b0725fabe93",
]
public_subnet_ids = [
  "subnet-0fd0443af9ac6f311",
  "subnet-04c5112d45ba3a45d",
  "subnet-080626882ac1d253e",
]
vpc_id = "vpc-0e470907c96317802"
