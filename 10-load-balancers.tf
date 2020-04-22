resource "aws_lb" "external_application_load_balancer" {
  name               = format("%s-external-app-lb", local.cluster_config.cluster_name)
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups = [
    module.application_lb_sg.security_group_id
  ]
  enable_cross_zone_load_balancing = true

  tags = merge(
    local.common_tags,
    map(
      "Name", format("%s-external-app-lb", local.cluster_config.cluster_name)
    )
  )
}