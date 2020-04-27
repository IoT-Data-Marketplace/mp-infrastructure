resource "aws_launch_template" "eks_worker_group_launch_template" {
  name = format("%s-%s-worker-group-lt-%s", var.cluster_name, var.worker_group_name, var.aws_region)

  ebs_optimized = var.ebs_optimized

  user_data = base64encode(data.template_file.launch_template_userdata.rendered)

  iam_instance_profile {
    arn = var.eks_worker_instance_profile_arn
  }

  network_interfaces {
    associate_public_ip_address = lookup(var.network_interface_config, "associate_public_ip_address")
    delete_on_termination       = lookup(var.network_interface_config, "delete_on_termination")
    security_groups             = var.security_group_ids
    description                 = format("%s-%s-network-interface-%s", var.cluster_name, var.worker_group_name, var.aws_region)
  }

  block_device_mappings {
    device_name = data.aws_ami.eks_worker.root_device_name
    ebs {
      volume_size           = lookup(var.root_ebs_device_config, "volume_size")
      volume_type           = lookup(var.root_ebs_device_config, "volume_type")
      encrypted             = lookup(var.root_ebs_device_config, "encrypted")
      delete_on_termination = lookup(var.root_ebs_device_config, "delete_on_termination")
    }
  }


  image_id      = data.aws_ami.eks_worker.id
  instance_type = var.instance_type
  key_name      = var.key_name

}

data "aws_ami" "eks_worker" {
  filter {
    name = "name"
    values = [
      format("amazon-eks-node-%s-v*", var.eks_kubernetes_version)
    ]
  }
  most_recent = true
  # Owner ID of AWS EKS team
  owners = ["602401143452"]
}


data "template_file" "launch_template_userdata" {
  template = file("${path.module}/templates/worker-bootstrap.tmpl")
  vars = {
    cluster_name         = var.cluster_name
    endpoint             = var.cluster_endpoint
    cluster_auth_base64  = var.cluster_certificate_authority_data
    bootstrap_extra_args = var.bootstrap_extra_args
    kubelet_extra_args = format("%s,%s", var.instance_lifecycle == "spot" ?
      "--node-labels=kubernetes.io/lifecycle=spot" :
      "--node-labels=kubernetes.io/lifecycle=normal"
    , format(" %s", var.kubelet_extra_args))
    userdata_template_extra_args = var.userdata_template_extra_args
  }
}