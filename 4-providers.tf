terraform {
  required_version = ">= 0.12.24"
}

provider "aws" {
  version    = ">= 2.58.0"
  region     = local.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_cluster.cluster_id
}

provider "kubernetes" {
  host                   = module.eks_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_cluster.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "1.11.1"
}

provider "helm" {
  version = "1.1.1"
  kubernetes {
    host                   = module.eks_cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_cluster.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    load_config_file       = false
  }
}