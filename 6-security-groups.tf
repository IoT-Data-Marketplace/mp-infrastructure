module "vpn_sg" {
  source      = "./modules/security-group"
  description = "SG Attached to the Client VPN Endpoint"
  sg_name     = format("%s-vpn-sg", local.cluster_config.cluster_name)
  vpc_id      = module.vpc.vpc_id
  aws_region  = local.aws_region
  ingress_cidr_block_rules = {
    access-all-from-vpn-clients = {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr_blocks = [
        var.vpn_config["client_cidr_block"]
      ]
    }
  }
}

module "cluster_sg" {
  source      = "./modules/security-group"
  description = "SG Attached to the EKS Cluster"
  sg_name     = format("%s-cluster-sg-%s", local.cluster_config.cluster_name, local.aws_region)
  vpc_id      = module.vpc.vpc_id
  aws_region  = local.aws_region
  ingress_cidr_block_rules = {
    k8s-api-access-from-vpc = {
      //      https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr_blocks = [
        local.vpc_config.cidr
      ]
    }
  }
}

module "worker_nodes_sg" {
  source      = "./modules/security-group"
  description = "SG Attached to the EKS Worker Nodes"
  sg_name     = format("%s-cluster-workers-sg-%s", local.cluster_config.cluster_name, local.aws_region)
  vpc_id      = module.vpc.vpc_id
  allow_icmp  = true
  aws_region  = local.aws_region
  ingress_cidr_block_rules = {
    node-access-from-vpc = {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr_blocks = [
        local.vpc_config.cidr
      ]
    }
  }
}