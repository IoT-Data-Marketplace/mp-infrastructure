variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "description" {
  description = "The SG Description"
}

variable "sg_name" {
  description = "The name of the security group"
}

variable "aws_region" {
  description = "AWS Region"
}

variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "The Common tags"
}

variable "allow_icmp" {
  type        = bool
  default     = false
  description = "Allow ping requests"
}

variable "ingress_cidr_block_rules" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default     = {}
  description = "A List of Maps containing Igress Variables for configuring the Security Group with CIDR Blocks"
}

variable "ingress_source_sg_rules" {
  type = map(object({
    from_port              = number
    to_port                = number
    protocol               = string
    source_security_groups = map(string)
  }))
  default     = {}
  description = "A Map of Ingress Variables for configuring the Security Group with Source Security Groups"
}

variable "ingress_self_source_sg_rules" {
  default     = []
  description = "A Map of Ingress Variables for configuring the Security Group with Self Source SG"
}

variable "egress_cidr_block_rules" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
    "default-egress-to-everywhere" = {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr_blocks = [
        "0.0.0.0/0"
      ]
    }
  }
  description = "A Map of Egress Variables for configuring the Security Group with CIDR Blocks"
}

variable "egress_source_sg_rules" {
  type = map(object({
    from_port              = number
    to_port                = number
    protocol               = string
    source_security_groups = list(string)
  }))
  default     = {}
  description = "A Map of Egress Variables for configuring the Security Group with Source Security Groups"
}