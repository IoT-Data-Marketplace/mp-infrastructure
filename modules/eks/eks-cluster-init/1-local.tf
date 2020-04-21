locals {
  cluster = {
    name                       = lookup(var.cluster_params, "cluster_name")
    id                         = lookup(var.cluster_params, "cluster_id")
    aws_region                 = lookup(var.cluster_params, "aws_region")
    endpoint                   = lookup(var.cluster_params, "cluster_endpoint")
    certificate_authority_data = lookup(var.cluster_params, "cluster_certificate_authority_data")
  }
}