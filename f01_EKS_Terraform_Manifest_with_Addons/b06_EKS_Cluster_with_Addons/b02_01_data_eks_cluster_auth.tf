/*
Data Source: aws_eks_cluster_auth
    Get an authentication token to communicate with an EKS cluster.

    Uses IAM credentials from the AWS provider to generate a temporary token that is compatible with AWS IAM Authenticator authentication. 
    This can be used to authenticate to an EKS cluster or to a cluster that has the AWS IAM Authenticator server configured.

*/

# Datasource: EKE Cluster Auth
data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = "${aws_eks_cluster.eks_control_plane.id}"
}
