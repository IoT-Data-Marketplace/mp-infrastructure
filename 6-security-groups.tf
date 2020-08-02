//module "vpn_sg" {
//  source      = "./modules/security-group"
//  description = "SG Attached to the Client VPN Endpoint"
//  sg_name     = format("%s-vpn-sg", local.cluster_config.cluster_name)
//  vpc_id      = module.vpc.vpc_id
//  aws_region  = local.aws_region
//  ingress_cidr_block_rules = {
//    access-all-from-vpn-clients = {
//      from_port = 0
//      to_port   = 0
//      protocol  = "-1"
//      cidr_blocks = [
//        var.vpn_config["client_cidr_block"]
//      ]
//    }
//  }
//}

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

module "application_lb_sg" {
  source      = "./modules/security-group"
  description = "SG Attached to the Application Internet Facing Cluster"
  sg_name     = format("%s-cluster-application-lb-sg", local.cluster_config.cluster_name)
  vpc_id      = module.vpc.vpc_id
  aws_region  = local.aws_region
  ingress_cidr_block_rules = {
    http-cluster-access = {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
      cidr_blocks = [
        "0.0.0.0/0"
      ]
    }
    https-cluster-access = {
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
      cidr_blocks = [
        "0.0.0.0/0"
      ]
    }
  }
}

module "rds_db_sg" {
  source      = "./modules/security-group"
  description = "SG Attached to the RDS DB"
  sg_name     = format("%s-rds-db-%s", local.cluster_config.cluster_name, local.aws_region)
  vpc_id      = module.vpc.vpc_id
  aws_region  = local.aws_region
  ingress_cidr_block_rules = {
    allow-db-access-from-vpc = {
      from_port = 5432
      to_port   = 5432
      protocol  = "tcp"
      cidr_blocks = [
        local.vpc_config.cidr
      ]
    }
    allow-db-access-from-tf-executor = {
      from_port = 5432
      to_port   = 5432
      protocol  = "tcp"
      cidr_blocks = [
        format("%s/32", chomp(data.http.local_tf_executor_ip.body))
      ]
    }
  }
}



module "test_client_instance_sg" {
  source      = "./modules/security-group"
  description = "SG Attached to the Test Client Nodes"
  sg_name     = format("%s-test-client-instance-sg-%s", local.cluster_config.cluster_name, local.aws_region)
  vpc_id      = module.vpc.vpc_id
  allow_icmp  = true
  aws_region  = local.aws_region
  ingress_cidr_block_rules = {
    node-access-from-vpc = {
      from_port = 22
      to_port   = 22
      protocol  = "tcp"
      cidr_blocks = [
        format("%s/32", chomp(data.http.local_tf_executor_ip.body))
      ]
    }
  }
}