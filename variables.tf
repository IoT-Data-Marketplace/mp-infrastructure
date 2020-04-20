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