resource "aws_alb_target_group" "mp_web_client_target_group" {
  name     = format("%s-web-tg", local.cluster_config.cluster_name)
  port     = local.ingress_config.mp_web_client_node_port
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled             = true
    interval            = 5
    protocol            = "HTTP"
    path                = "/"
    port                = local.ingress_config.mp_web_client_node_port
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
  }

  tags = merge(
    local.common_tags,
    map(
      "Name", format("%s-web-tg", local.cluster_config.cluster_name)
    )
  )
}

resource "aws_alb_target_group" "chartmuseum_target_group" {
  name     = format("%s-chartmuseum-tg", local.cluster_config.cluster_name)
  port     = local.ingress_config.chartmuseum_node_port
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled             = true
    interval            = 5
    protocol            = "HTTP"
    path                = "/health"
    port                = local.ingress_config.chartmuseum_node_port
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
  }

  tags = {
    "Name" = format("%s-chartmuseum-tg", local.cluster_config.cluster_name)
  }
}