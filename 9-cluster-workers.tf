locals {
  target_group_list = [
    aws_alb_target_group.istio_ingress_gateway_tg.arn,
    aws_alb_target_group.mp_web_client_target_group.arn,
    //    aws_alb_target_group.mp_api_gateway_target_group.arn,
    aws_alb_target_group.chartmuseum_target_group.arn,
    aws_alb_target_group.k8s_dashboard_target_group.arn,
    aws_alb_target_group.grafana_target_group.arn
  ]
}

module "spot_worker_group_1" {
  source                             = "./modules/eks/eks-worker-group"
  worker_group_name                  = "spot-worker-group-1"
  aws_region                         = local.aws_region
  instance_type                      = "m5.large"
  cluster_certificate_authority_data = module.eks_cluster.cluster_certificate_authority_data
  cluster_endpoint                   = module.eks_cluster.cluster_endpoint
  cluster_name                       = local.cluster_config.cluster_name
  eks_kubernetes_version             = local.cluster_config.eks_kubernetes_version
  eks_worker_instance_profile_arn    = module.eks_worker_iam.eks_worker_instance_profile_arn
  key_name                           = aws_key_pair.deployer.key_name
  security_group_ids = [
    module.worker_nodes_sg.security_group_id
  ]
  instance_lifecycle = "spot"
  subnet_ids         = module.vpc.private_subnets
  asg_config = {
    min_size = 1
    max_size = 3
  }
  spot_instance_config = {
    spot_allocation_strategy = "lowest-price"
    spot_instance_pools      = 2
  }
  target_group_arns  = local.target_group_list
  ebs_optimized      = false
  kubelet_extra_args = "--node-labels=nodegroup=app"
  additional_tags = {
    nodegroup = "app"
  }
}

module "kafka_spot_worker_group_t3_medium" {
  source                             = "./modules/eks/eks-worker-group-per-az"
  worker_group_name                  = "kafka-spot-worker-group-t3-medium"
  aws_region                         = local.aws_region
  instance_type                      = "t3.medium"
  cluster_certificate_authority_data = module.eks_cluster.cluster_certificate_authority_data
  cluster_endpoint                   = module.eks_cluster.cluster_endpoint
  cluster_name                       = local.cluster_config.cluster_name
  eks_kubernetes_version             = local.cluster_config.eks_kubernetes_version
  eks_worker_instance_profile_arn    = module.eks_worker_iam.eks_worker_instance_profile_arn
  key_name                           = aws_key_pair.deployer.key_name
  instance_lifecycle                 = "spot"
  security_group_ids = [
    module.worker_nodes_sg.security_group_id
  ]
  subnet_ids = module.vpc.private_subnets
  asg_config = {
    min_size = 1
    max_size = 1
  }
  spot_instance_config = {
    spot_allocation_strategy = "lowest-price"
    spot_instance_pools      = 2
  }
  target_group_arns  = []
  ebs_optimized      = true
  kubelet_extra_args = "--node-labels=nodegroup=kafka"
  additional_tags = {
    nodegroup = "kafka"
  }
}