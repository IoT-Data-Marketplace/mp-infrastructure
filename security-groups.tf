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