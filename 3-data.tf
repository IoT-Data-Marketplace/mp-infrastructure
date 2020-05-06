data "aws_availability_zones" "available_zones" {}

data "aws_caller_identity" "caller_identity" {}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

data "http" "local_tf_executor_ip" {
  url = "http://ipv4.icanhazip.com"
}