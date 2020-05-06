locals {

  aws_region = "eu-central-1"

  cluster_config = {
    cluster_name           = "iot-data-mp"
    eks_kubernetes_version = "1.15"
  }


  vpc_config = {
    name = "iot-data-mp"
    cidr = "10.128.0.0/16"

    private_subnets = {
      create                      = true
      create_multi_az_nat_gateway = false
      cidr_blocks = [
        "10.128.0.0/20",
        // 255.255.240.0 NETMASK 10.128.0.1 FIRST IP 10.128.15.254 LAST IP 4,096 COUNT
        "10.128.16.0/20",
        // 255.255.240.0 NETMASK 10.128.16.1 FIRST IP 10.128.31.254 LAST IP 4,096 COUNT
        "10.128.32.0/20",
        // 255.255.240.0 NETMASK 10.128.32.1 FIRST IP 10.128.47.254 LAST IP 4,096 COUNT
      ]
    }

    public_subnets = {
      cidr_blocks = [
        "10.128.244.0/22",
        // 255.255.252.0 NETMASK 10.128.244.1 FIRST IP 10.128.247.254 LAST IP 1,024 COUNT
        "10.128.248.0/22",
        // 255.255.252.0 NETMASK 10.128.248.1 FIRST IP 10.128.251.254 LAST IP 1,024 COUNT
        "10.128.252.0/22"
        // 255.255.252.0 NETMASK 10.128.252.1 FIRST IP 10.128.255.254 LAST IP 1,024 COUNT
      ]
    }

  }

  common_tags = {
    KubernetesCluster = local.cluster_config.cluster_name
    Region            = local.aws_region
  }

  dns_params = {
    base_domain_name = "iot-data-mp.com"
    route53_zone_id  = "Z0309573B5CCF4IK8GYQ"
  }

  dns_config = {
    cluster_admin_wildcard_domain = format("*.%s", local.dns_params.base_domain_name)
    k8s_dashboard_domain_name     = format("dashboard.%s", local.dns_params.base_domain_name)
    grafana_domain_name           = format("grafana.%s", local.dns_params.base_domain_name)
    prometheus_domain_name        = format("prometheus.%s", local.dns_params.base_domain_name)
    grafana_domain_name           = format("grafana.%s", local.dns_params.base_domain_name)
    chartmuseum_domain_name       = format("chartmuseum.%s", local.dns_params.base_domain_name)
  }

  ingress_config = {
    k8s_dashboard_node_port  = 30000
    chartmuseum_node_port    = 30001
    grafana_node_port        = 30010
    mp_web_client_node_port  = 30100
    mp_api_gateway_node_port = 30200
  }

  namespaces = {
    iot-mp-system = {}
  }

  eks_additional_user_access = [
    {
      user_arn = aws_iam_user.k8s_user.arn
      username = "mt-k8s-user"
    }
  ]

}