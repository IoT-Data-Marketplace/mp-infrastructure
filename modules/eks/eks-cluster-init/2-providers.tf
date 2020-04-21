data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster.id
}

provider "kubernetes" {
  host                   = local.cluster.endpoint
  cluster_ca_certificate = base64decode(local.cluster.certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "1.11.1"
}

provider "helm" {
  version = "1.1.1"
  kubernetes {
    host                   = local.cluster.endpoint
    cluster_ca_certificate = base64decode(local.cluster.certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    load_config_file       = false
  }
}
