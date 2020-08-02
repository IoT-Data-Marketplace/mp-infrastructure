resource "aws_launch_template" "test_client_launch_template" {
  name = format("%s-%s", var.cluster_name, var.test_client_name)
  user_data = base64encode(join("\n", [
    data.template_file.test_client_instance_startup_data.rendered,
    var.docker_startup_script
  ]))

  key_name = var.key_name

  image_id      = "ami-00edb93a4d68784e3"
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups = [
      var.security_group_id
    ]
  }

}

data "template_file" "test_client_instance_startup_data" {
  template = file("${path.module}/user-data/user-data.sh")
}


resource "aws_autoscaling_group" "test_client_asg" {
  name     = format("%s-%s", var.cluster_name, var.test_client_name)
  max_size = var.instance_number
  min_size = var.instance_number

  vpc_zone_identifier = var.public_subnets

  launch_template {
    id      = aws_launch_template.test_client_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = format("%s-%s", var.cluster_name, var.test_client_name)
    propagate_at_launch = true
  }

}