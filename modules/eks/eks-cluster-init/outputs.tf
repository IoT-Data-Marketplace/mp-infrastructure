output "k8s_dashboard_target_group_arn" {
  value = aws_alb_target_group.k8s_dashboard_target_group.*.arn
}