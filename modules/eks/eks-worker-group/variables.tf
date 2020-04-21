variable "cluster_name" {
  description = "Name of the Cluster the VPC is deployed to"
}

variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "The Common tags to attach to the resources"
}

variable "subnet_ids" {
  description = "List of subnet IDs. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane."
}

variable "worker_group_name" {
  description = "The name of the worker group."
}
variable "aws_region" {
  description = "The AWS region in which the infrastructure will be deployed"
}

variable "instance_type" {
  description = "The type of the worker group instances."
}

variable "ebs_optimized" {
  type        = bool
  default     = true
  description = "If true, the launched EC2 instance will be EBS-optimized."
}

variable "security_group_ids" {
  type        = list(string)
  description = "A list of security group IDs to associate with."
}

variable "target_group_arns" {
  type        = list(string)
  description = "A list of Target Groups to attach to the Worker Nodes"
}

variable "cluster_certificate_authority_data" {
  description = ""
}

variable "cluster_endpoint" {
  description = ""
}

variable "bootstrap_extra_args" {
  type        = string
  default     = ""
  description = ""
}

variable "kubelet_extra_args" {
  type        = string
  default     = ""
  description = ""
}

variable "userdata_template_extra_args" {
  type        = string
  default     = ""
  description = ""
}

variable "network_interface_config" {
  description = "Configuration for the network interface for each instance."
  type = object({
    associate_public_ip_address = bool
    delete_on_termination       = bool
  })
  default = {
    associate_public_ip_address = false
    delete_on_termination       = true
  }
}

variable "eks_kubernetes_version" {
  description = "The Kubernetes server version for the cluster."
}

variable "key_name" {
  description = " The key name to use for the instance."
}

variable "eks_worker_instance_profile_arn" {
  description = "The IAM Role ARN to associate to the worker nodes."
}

variable "root_ebs_device_config" {
  description = "Configuration for the root volume of the instances."
  type = object({
    volume_size           = number
    volume_type           = string
    encrypted             = bool
    delete_on_termination = bool
  })
  default = {
    volume_size           = 128
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }
}

variable "instance_lifecycle" {
  description = "Instance Lifecycle. Possible values: spot, on-demand. It defaults to on-demand"
  type        = string
  default     = "on-demand"
}

variable "spot_instance_config" {
  type = object({
    spot_allocation_strategy = string
    spot_instance_pools      = number
  })
  default = {
    instance_types           = ["m5.large", "m5.xlarge", "m5.2xlarge"]
    spot_allocation_strategy = "lowest-price"
    spot_instance_pools      = 2
  }
}

variable "asg_config" {
  description = "ASG Configuration"
  type = object({
    max_size = number
    min_size = number
  })
}

variable "cpu_average_config" {
  description = "CPU Average Utilization Config"
  type = object({
    enable      = bool
    cpu_average = number
  })
  default = {
    enable      = false
    cpu_average = 0
  }
}

variable "additional_tags" {
  type        = map(string)
  description = "Apply the additional tags to the ASG"
}