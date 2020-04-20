resource "aws_iam_role" "eks_cluster_iam_role" {
  name               = format("%s-cluster-iam-role", var.cluster_name)
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy_document.json
}

data "aws_iam_policy_document" "eks_assume_role_policy_document" {
  statement {
    effect = "Allow"
    sid    = "AllowEKSToAssumeRole"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "eks.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_iam_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_iam_role.name
}