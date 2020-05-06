module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.33.0"

  name = local.vpc_config.name

  cidr                 = local.vpc_config.cidr
  azs                  = slice(data.aws_availability_zones.available_zones.names, 0, 3)
  private_subnets      = local.vpc_config.private_subnets.cidr_blocks
  public_subnets       = local.vpc_config.public_subnets.cidr_blocks
  enable_dns_hostnames = true

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_s3_endpoint = true

  tags = map(
    "KubernetesCluster", local.cluster_config.cluster_name
  )

  private_subnet_tags = map(
    format("kubernetes.io/cluster/%s", local.cluster_config.cluster_name), "shared",
    "kubernetes.io/role/internal-elb", "1"
  )

  public_subnet_tags = map(
    format("kubernetes.io/cluster/%s", local.cluster_config.cluster_name), "shared",
    "kubernetes.io/role/elb", "1"
  )
}

//resource "aws_ec2_client_vpn_endpoint" "client_vpn_endpoint" {
//  client_cidr_block      = var.vpn_config["client_cidr_block"]
//  server_certificate_arn = var.vpn_config["server_certificate_arn"]
//  split_tunnel           = true
//  authentication_options {
//    type                       = "certificate-authentication"
//    root_certificate_chain_arn = var.vpn_config["root_certificate_chain_arn"]
//  }
//
//  connection_log_options {
//    enabled = false
//  }
//
//  tags = merge(
//    map(
//      "Name", format("%s-vpn-%s", local.vpc_config.name, local.aws_region),
//      "VPC", local.vpc_config.name
//    )
//  )
//}
//
//resource "aws_ec2_client_vpn_network_association" "vpn_network_association" {
//  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_endpoint.id
//  subnet_id              = module.vpc.public_subnets[0]
//}
//
resource "aws_key_pair" "deployer" {
  key_name   = format("%s-ssh-key-pair", local.vpc_config.name)
  public_key = var.ssh_public_key

  tags = {
    "Region" = local.aws_region
  }
}