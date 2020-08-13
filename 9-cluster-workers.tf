locals {
  target_group_list = [
    //    aws_alb_target_group.istio_ingress_gateway_tg.arn,
    //    aws_alb_target_group.mp_web_client_target_group.arn,
    //    aws_alb_target_group.mp_api_gateway_target_group.arn,
    //    aws_alb_target_group.chartmuseum_target_group.arn,
    //    aws_alb_target_group.k8s_dashboard_target_group.arn,
    //    aws_alb_target_group.grafana_target_group.arn
  ]
}

module "spot_kube_system_worker_group" {
  source                             = "./modules/eks/eks-worker-group"
  worker_group_name                  = "spot-kube-system-worker-group-1"
  aws_region                         = local.aws_region
  instance_type                      = "t3.medium"
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
  target_group_arns = [
    aws_alb_target_group.chartmuseum_target_group.arn,
    aws_alb_target_group.k8s_dashboard_target_group.arn,
    aws_alb_target_group.grafana_target_group.arn
  ]
  ebs_optimized      = false
  kubelet_extra_args = "--node-labels=nodegroup=kube-system"
  additional_tags = {
    nodegroup = "kube-system"
  }
}

module "prometheus_worker_group" {
  source                             = "./modules/eks/eks-worker-group"
  worker_group_name                  = "prometheus-worker-group"
  aws_region                         = local.aws_region
  instance_type                      = "t3.large"
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
    max_size = 1
  }
  spot_instance_config = {
    spot_allocation_strategy = "lowest-price"
    spot_instance_pools      = 2
  }
  target_group_arns = [
    aws_alb_target_group.chartmuseum_target_group.arn,
    aws_alb_target_group.k8s_dashboard_target_group.arn,
    aws_alb_target_group.grafana_target_group.arn
  ]
  ebs_optimized      = false
  kubelet_extra_args = "--node-labels=nodegroup=prometheus"
  additional_tags = {
    nodegroup = "prometheus"
  }
}

module "spot_iot_app_worker_group" {
  source                             = "./modules/eks/eks-worker-group"
  worker_group_name                  = "spot-iot-app-worker-group-1"
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
    min_size = 0
    max_size = 10
  }
  spot_instance_config = {
    spot_allocation_strategy = "lowest-price"
    spot_instance_pools      = 2
  }
  target_group_arns  = []
  ebs_optimized      = false
  kubelet_extra_args = "--node-labels=nodegroup=iot-app"
  additional_tags = {
    nodegroup = "iot-app"
  }
}

module "spot_iot_app_2_worker_group" {
  source                             = "./modules/eks/eks-worker-group"
  worker_group_name                  = "spot-iot-app-worker-group-2"
  aws_region                         = local.aws_region
  instance_type                      = "t3.medium"
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
    min_size = 0
    max_size = 10
  }
  spot_instance_config = {
    spot_allocation_strategy = "lowest-price"
    spot_instance_pools      = 2
  }
  target_group_arns  = []
  ebs_optimized      = false
  kubelet_extra_args = "--node-labels=nodegroup=iot-app"
  additional_tags = {
    nodegroup = "iot-app"
  }
}

module "spot_iot_app_3_worker_group" {
  source                             = "./modules/eks/eks-worker-group"
  worker_group_name                  = "spot-iot-app-worker-group-3"
  aws_region                         = local.aws_region
  instance_type                      = "t3.large"
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
    min_size = 0
    max_size = 10
  }
  spot_instance_config = {
    spot_allocation_strategy = "lowest-price"
    spot_instance_pools      = 2
  }
  target_group_arns  = []
  ebs_optimized      = false
  kubelet_extra_args = "--node-labels=nodegroup=iot-app"
  additional_tags = {
    nodegroup = "iot-app"
  }
}

module "spot_iot_app_4_worker_group" {
  source                             = "./modules/eks/eks-worker-group"
  worker_group_name                  = "spot-iot-app-worker-group-4"
  aws_region                         = local.aws_region
  instance_type                      = "m5.xlarge"
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
    min_size = 0
    max_size = 10
  }
  spot_instance_config = {
    spot_allocation_strategy = "lowest-price"
    spot_instance_pools      = 2
  }
  target_group_arns  = []
  ebs_optimized      = false
  kubelet_extra_args = "--node-labels=nodegroup=iot-app"
  additional_tags = {
    nodegroup = "iot-app"
  }
}

module "spot_iot_app_5_worker_group" {
  source                             = "./modules/eks/eks-worker-group"
  worker_group_name                  = "spot-iot-app-worker-group-5"
  aws_region                         = local.aws_region
  instance_type                      = "c5n.large"
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
    min_size = 0
    max_size = 20
  }
  spot_instance_config = {
    spot_allocation_strategy = "lowest-price"
    spot_instance_pools      = 2
  }
  target_group_arns  = []
  ebs_optimized      = false
  kubelet_extra_args = "--node-labels=nodegroup=iot-app"
  additional_tags = {
    nodegroup = "iot-app"
  }
}

module "spot_iot_app_6_worker_group" {
  source                             = "./modules/eks/eks-worker-group"
  worker_group_name                  = "spot-iot-app-worker-group-6"
  aws_region                         = local.aws_region
  instance_type                      = "c5n.xlarge"
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
    min_size = 0
    max_size = 20
  }
  spot_instance_config = {
    spot_allocation_strategy = "lowest-price"
    spot_instance_pools      = 2
  }
  target_group_arns  = []
  ebs_optimized      = false
  kubelet_extra_args = "--node-labels=nodegroup=iot-app"
  additional_tags = {
    nodegroup = "iot-app"
  }
}

module "spot_iot_app_7_worker_group" {
  source                             = "./modules/eks/eks-worker-group"
  worker_group_name                  = "spot-iot-app-worker-group-7"
  aws_region                         = local.aws_region
  instance_type                      = "t3.large"
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
    min_size = 0
    max_size = 10
  }
  spot_instance_config = {
    spot_allocation_strategy = "lowest-price"
    spot_instance_pools      = 2
  }
  target_group_arns  = []
  ebs_optimized      = false
  kubelet_extra_args = "--node-labels=nodegroup=iot-app,iot-service=bc-client"
  additional_tags = {
    nodegroup   = "iot-app"
    iot-service = "bc-client"
  }
}

module "eth_node_spot_worker_group_t3_small" {
  source                             = "./modules/eks/eks-worker-group-per-az"
  worker_group_name                  = "spot-eth-node-worker-group-t3-small"
  aws_region                         = local.aws_region
  instance_type                      = "t3.small"
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
    min_size = 0
    max_size = 2
  }
  spot_instance_config = {
    spot_allocation_strategy = "lowest-price"
    spot_instance_pools      = 2
  }
  target_group_arns  = []
  ebs_optimized      = true
  kubelet_extra_args = "--node-labels=nodegroup=eth-node"
  additional_tags = {
    nodegroup = "eth-node"
  }
}

module "spot_istio_worker_group" {
  source                             = "./modules/eks/eks-worker-group"
  worker_group_name                  = "spot-istio-worker-group-1"
  aws_region                         = local.aws_region
  instance_type                      = "c5n.large"
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
    min_size = 0
    max_size = 5
  }
  spot_instance_config = {
    spot_allocation_strategy = "lowest-price"
    spot_instance_pools      = 2
  }
  target_group_arns = [
    aws_alb_target_group.istio_ingress_gateway_tg.arn
  ]
  ebs_optimized      = false
  kubelet_extra_args = "--node-labels=nodegroup=istio"
  additional_tags = {
    nodegroup = "istio"
  }
}

module "spot_kafka_addons_worker_group" {
  source                             = "./modules/eks/eks-worker-group"
  worker_group_name                  = "spot-kafka-addons-worker-group-1"
  aws_region                         = local.aws_region
  instance_type                      = "c5n.xlarge"
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
    min_size = 0
    max_size = 5
  }
  spot_instance_config = {
    spot_allocation_strategy = "lowest-price"
    spot_instance_pools      = 2
  }
  target_group_arns  = []
  ebs_optimized      = false
  kubelet_extra_args = "--node-labels=nodegroup=kafka-addons"
  additional_tags = {
    nodegroup = "kafka-addons"
  }
}

module "kafka_spot_worker_group_t3_medium" {
  source                             = "./modules/eks/eks-worker-group-per-az"
  worker_group_name                  = "spot-kafka-cluster-worker-group-t3-medium"
  aws_region                         = local.aws_region
  instance_type                      = "m5.xlarge"
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
    min_size = 0
    max_size = 2
  }
  spot_instance_config = {
    spot_allocation_strategy = "lowest-price"
    spot_instance_pools      = 2
  }
  target_group_arns  = []
  ebs_optimized      = true
  kubelet_extra_args = "--node-labels=nodegroup=kafka-cluster"
  additional_tags = {
    nodegroup = "kafka-cluster"
  }
}