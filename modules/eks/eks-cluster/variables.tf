variable "cluster_name" {
  description = "Name of the Cluster the VPC is deployed to"
}

variable "subnet_ids" {
  description = "List of subnet IDs. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane."
}

variable "eks_kubernetes_version" {
  description = "The Kubernetes server version for the cluster."
}

variable "enable_endpoint_private_access" {
  type        = bool
  default     = true
  description = " Indicates whether or not the Amazon EKS private API server endpoint is enabled."
}

variable "enable_endpoint_public_access" {
  type        = bool
  default     = false
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled."
}

variable "cluster_security_group_ids" {
  type        = list(string)
  default     = []
  description = "List of security group IDs for the cross-account elastic network interfaces that Amazon EKS creates to use to allow communication between your worker nodes and the Kubernetes control plane."
}