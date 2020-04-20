resource "aws_iam_instance_profile" "eks_worker_instance_profile" {
  name = format("%s-cluster-worker-instance-profile", var.cluster_name)
  role = aws_iam_role.eks_worker_iam_role.name
}

resource "aws_iam_role" "eks_worker_iam_role" {
  name               = format("%s-cluster-worker-iam-role", var.cluster_name)
  assume_role_policy = data.aws_iam_policy_document.eks_worker_assume_role_policy_document.json
}

data "aws_iam_policy_document" "eks_worker_assume_role_policy_document" {
  statement {
    sid = "EKSWorkerAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_worker_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker_iam_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_worker_iam_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_worker_iam_role.name
}