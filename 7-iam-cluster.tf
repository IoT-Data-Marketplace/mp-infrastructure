module "eks_worker_iam" {
  source       = "./modules/eks/eks-worker-iam"
  cluster_name = local.cluster_config.cluster_name
}

data "aws_iam_policy_document" "worker_nodes_additional_policy_document" {
  statement {
    sid = "EKSWorkerAutoscalingPermissions"
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]

    effect = "Allow"
    resources = [
      "*"
    ]
  }

  statement {
    sid = "EKSWorkerAdditionalPermissions"
    actions = [
      "sts:*",
      "s3:*",
    ]

    effect = "Allow"
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "worker_nodes_additional_policy" {
  name   = format("%s-cluster-worker-nodes-additional-policy", local.cluster_config.cluster_name)
  policy = data.aws_iam_policy_document.worker_nodes_additional_policy_document.json
  role   = module.eks_worker_iam.eks_worker_iam_role_id
}