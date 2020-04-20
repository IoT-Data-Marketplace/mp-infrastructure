output "eks_worker_instance_profile_arn" {
  description = "The ARN of the Instance Profile attached to the EKS Worker Nodes"
  value       = aws_iam_instance_profile.eks_worker_instance_profile.arn
}

output "eks_worker_iam_role_arn" {
  description = "The ARN of the IAM Role attached to the EKS Worker Nodes"
  value       = aws_iam_role.eks_worker_iam_role.arn
}

output "eks_worker_iam_role_id" {
  description = "The ID of the IAM Role attached to the EKS Worker Nodes"
  value       = aws_iam_role.eks_worker_iam_role.id
}