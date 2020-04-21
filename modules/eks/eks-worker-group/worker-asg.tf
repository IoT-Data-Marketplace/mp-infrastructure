resource "aws_autoscaling_group" "eks_worker_asg" {
  name     = format("%s-%s-asg", var.cluster_name, var.worker_group_name)
  max_size = lookup(var.asg_config, "max_size")
  min_size = lookup(var.asg_config, "min_size")

  target_group_arns = var.target_group_arns

  vpc_zone_identifier = var.subnet_ids


  dynamic "launch_template" {
    for_each = var.instance_lifecycle == "spot" ? [] : ["on-demand"]
    content {
      id      = aws_launch_template.eks_worker_group_launch_template.id
      version = "$Latest"
    }
  }


  dynamic "mixed_instances_policy" {
    for_each = var.instance_lifecycle == "spot" ? ["spot"] : []
    content {
      launch_template {
        launch_template_specification {
          launch_template_id = aws_launch_template.eks_worker_group_launch_template.id
          version            = "$Latest"
        }
        override {
          instance_type = var.instance_type
        }
      }
      instances_distribution {
        spot_allocation_strategy                 = lookup(var.spot_instance_config, "spot_allocation_strategy")
        spot_instance_pools                      = lookup(var.spot_instance_config, "spot_instance_pools")
        on_demand_base_capacity                  = 0
        on_demand_percentage_above_base_capacity = 0
      }
    }
  }

  dynamic "tag" {
    for_each = var.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  tag {
    key                 = "Name"
    value               = format("%s-%s-asg-%s", var.cluster_name, var.worker_group_name, var.aws_region)
    propagate_at_launch = true
  }

  tag {
    key                 = format("kubernetes.io/cluster/%s", var.cluster_name)
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = format("k8s.io/cluster-autoscaler/%s", var.cluster_name)
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = true
    propagate_at_launch = true
  }

  // required in order to be able to scale from 0 with nodeaffinity enabled
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/instance-type"
    value               = var.instance_type
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/lifecycle"
    value               = var.instance_lifecycle == "spot" ? "spot" : "normal"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.additional_tags
    iterator = tag
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

}