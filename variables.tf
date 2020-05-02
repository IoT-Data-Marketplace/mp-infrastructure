variable "aws_access_key" {
}

variable "aws_secret_key" {
}

variable "vpn_config" {
  type = object({
    server_certificate_arn     = string
    root_certificate_chain_arn = string
    client_cidr_block          = string
  })
}

variable "ssh_public_key" {}

variable "eks_additional_access_roles" {
  description = "Additional Roles with the Cluster Access"
  type = list(object({
    role_arn = string
    username = string
  }))
  default = []
}


variable "grafana_password" {
  type = string
}

variable "chartmuseum_user" {
  type = string
}

variable "chartmuseum_password" {
  type = string
}