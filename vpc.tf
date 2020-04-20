module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.33.0"

  name = local.vpc_config.name

  cidr            = local.vpc_config.cidr
  azs             = slice(data.aws_availability_zones.available_zones.names, 0, 3)
  private_subnets = local.vpc_config.private_subnets.cidr_blocks
  public_subnets  = local.vpc_config.public_subnets.cidr_blocks

  enable_nat_gateway = true
  single_nat_gateway = true
//  enable_s3_endpoint = true

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