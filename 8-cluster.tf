module "eks_cluster" {
  source                        = "./modules/eks/eks-cluster"
  cluster_name                  = local.cluster_config.cluster_name
  eks_kubernetes_version        = local.cluster_config.eks_kubernetes_version
  enable_endpoint_public_access = false
  subnet_ids                    = sort(concat(module.vpc.public_subnets, module.vpc.private_subnets))
  cluster_security_group_ids = [
    module.cluster_sg.security_group_id
  ]
}