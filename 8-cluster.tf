module "eks_cluster" {
  source                        = "./modules/eks/eks-cluster"
  cluster_name                  = local.cluster_config.cluster_name
  eks_kubernetes_version        = local.cluster_config.eks_kubernetes_version
  enable_endpoint_public_access = true
  subnet_ids                    = sort(concat(module.vpc.public_subnets, module.vpc.private_subnets))
  cluster_security_group_ids = [
    module.cluster_sg.security_group_id
  ]
}

module "eks_cluster_init" {
  source = "./modules/eks/eks-cluster-init"
  cluster_params = {
    cluster_name                       = local.cluster_config.cluster_name
    cluster_id                         = module.eks_cluster.cluster_id
    cluster_certificate_authority_data = module.eks_cluster.cluster_certificate_authority_data
    cluster_endpoint                   = module.eks_cluster.cluster_endpoint
    aws_region                         = local.aws_region
  }
  eks_worker_iam_role_arn = module.eks_worker_iam.eks_worker_iam_role_arn
  eks_additional_user_access = [
    {
      user_arn = aws_iam_user.k8s_user.arn
      username = "mt-k8s-user"
    }
  ]

  namespace_config = local.namespaces

  common_tags = local.common_tags
  k8s_dashboard_config = {
    install               = true
    nodePort              = local.ingress_config.k8s_dashboard_node_port
    dashboard_domain_name = local.dns_config.k8s_dashboard_domain_name
  }
  load_balancer_params = {
    https_listener_arn = aws_lb_listener.application_lb_https_listener.arn
    dns_name           = aws_lb.external_application_load_balancer.dns_name
    zone_id            = aws_lb.external_application_load_balancer.zone_id
  }
  route_53_zone_id = local.dns_params.route53_zone_id
  vpc_id           = module.vpc.vpc_id
}