resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_iam_role.arn

  version = var.eks_kubernetes_version

  vpc_config {
    endpoint_private_access = var.enable_endpoint_private_access
    endpoint_public_access  = var.enable_endpoint_public_access
    security_group_ids      = var.cluster_security_group_ids
    subnet_ids              = var.subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSServicePolicy,
  ]
}
