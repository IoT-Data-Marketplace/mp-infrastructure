variable "cluster_params" {
  type = object({
    cluster_name                       = string
    cluster_id                         = string
    cluster_certificate_authority_data = string
    cluster_endpoint                   = string
    aws_region                         = string
  })
}


variable "eks_worker_iam_role_arn" {
  description = "The ARN of the IAM Role attached to the EKS Worker Nodes"
}

variable "eks_additional_access_roles" {
  description = "Additional Roles with the Cluster Access"
  type = list(object({
    role_arn = string
    username = string
  }))
  default = []
}

variable "eks_additional_user_access" {
  description = "Additional Users with the Cluster Access"
  type = list(object({
    user_arn = string
    username = string
  }))
  default = []
}

variable "common_tags" {
  type = map(string)
}

variable "namespace_config" {
  type = map(object({}))
}

variable "k8s_dashboard_config" {
  type = object({
    install               = bool
    nodePort              = number
    dashboard_domain_name = string
  })
}

variable "vpc_id" {}

variable "route_53_zone_id" {}

variable "load_balancer_params" {
  type = object({
    https_listener_arn = string
    dns_name           = string
    zone_id            = string
  })
}

variable "install_metrics_server" {
  type    = bool
  default = true
}

variable "install_cluster_autoscaler" {
  type    = bool
  default = true
}