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

variable "namespace_config" {
  type = map(object({}))
}
