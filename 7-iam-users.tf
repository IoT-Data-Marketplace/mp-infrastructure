resource "aws_iam_user" "k8s_user" {
  name = "mt-k8s-user"
  path = "/k8s/"

  tags = {
    Name = "mt-k8s-user"
    ClusterName = local.cluster_config.cluster_name
  }
}

resource "aws_iam_user_policy" "k8s_user_policy" {
  name = "k8s_user_policy"
  user = aws_iam_user.k8s_user.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster",
                "eks:ListClusters"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}