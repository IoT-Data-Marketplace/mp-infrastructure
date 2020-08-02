module "test_publishers" {
  source                = "./modules/test-clients"
  test_client_name      = "test-publishers"
  cluster_name          = local.cluster_config.cluster_name
  docker_startup_script = data.template_file.publisher_template_file.rendered
  instance_number       = var.test_instances_config.publishers.instance_count
  instance_type         = var.test_instances_config.publishers.instance_type
  key_name              = aws_key_pair.deployer.key_name
  public_subnets        = module.vpc.public_subnets
  security_group_id     = module.test_client_instance_sg.security_group_id
}

data "template_file" "publisher_template_file" {
  template = file("${path.module}/installation-dependencies/templates/test-publisher-docker-startup-script.tmpl")
  vars = {
    sensor_1_address = var.test_instances_config.publishers.startup_data_config.sensor_1.address
    sensor_1_jwt     = var.test_instances_config.publishers.startup_data_config.sensor_1.jwt

    sensor_2_address = var.test_instances_config.publishers.startup_data_config.sensor_2.address
    sensor_2_jwt     = var.test_instances_config.publishers.startup_data_config.sensor_2.jwt

    sensor_3_address = var.test_instances_config.publishers.startup_data_config.sensor_3.address
    sensor_3_jwt     = var.test_instances_config.publishers.startup_data_config.sensor_3.jwt

    sensor_4_address = var.test_instances_config.publishers.startup_data_config.sensor_4.address
    sensor_4_jwt     = var.test_instances_config.publishers.startup_data_config.sensor_4.jwt

    sensor_5_address = var.test_instances_config.publishers.startup_data_config.sensor_5.address
    sensor_5_jwt     = var.test_instances_config.publishers.startup_data_config.sensor_5.jwt

    sensor_6_address = var.test_instances_config.publishers.startup_data_config.sensor_6.address
    sensor_6_jwt     = var.test_instances_config.publishers.startup_data_config.sensor_6.jwt

    sensor_7_address = var.test_instances_config.publishers.startup_data_config.sensor_7.address
    sensor_7_jwt     = var.test_instances_config.publishers.startup_data_config.sensor_7.jwt

    sensor_8_address = var.test_instances_config.publishers.startup_data_config.sensor_8.address
    sensor_8_jwt     = var.test_instances_config.publishers.startup_data_config.sensor_8.jwt

    sensor_9_address = var.test_instances_config.publishers.startup_data_config.sensor_9.address
    sensor_9_jwt     = var.test_instances_config.publishers.startup_data_config.sensor_9.jwt

    sensor_10_address = var.test_instances_config.publishers.startup_data_config.sensor_10.address
    sensor_10_jwt     = var.test_instances_config.publishers.startup_data_config.sensor_10.jwt

    sensor_11_address = var.test_instances_config.publishers.startup_data_config.sensor_11.address
    sensor_11_jwt     = var.test_instances_config.publishers.startup_data_config.sensor_11.jwt

    sensor_12_address = var.test_instances_config.publishers.startup_data_config.sensor_12.address
    sensor_12_jwt     = var.test_instances_config.publishers.startup_data_config.sensor_12.jwt

    sensor_13_address = var.test_instances_config.publishers.startup_data_config.sensor_13.address
    sensor_13_jwt     = var.test_instances_config.publishers.startup_data_config.sensor_13.jwt

    sensor_14_address = var.test_instances_config.publishers.startup_data_config.sensor_14.address
    sensor_14_jwt     = var.test_instances_config.publishers.startup_data_config.sensor_14.jwt

    sensor_15_address = var.test_instances_config.publishers.startup_data_config.sensor_15.address
    sensor_15_jwt     = var.test_instances_config.publishers.startup_data_config.sensor_15.jwt
  }
}


module "test_subscribers" {
  source                = "./modules/test-clients"
  test_client_name      = "test-subscribers"
  cluster_name          = local.cluster_config.cluster_name
  docker_startup_script = data.template_file.subscriber_template_file.rendered
  instance_number       = var.test_instances_config.subscribers.instance_count
  instance_type         = var.test_instances_config.subscribers.instance_type
  key_name              = aws_key_pair.deployer.key_name
  public_subnets        = module.vpc.public_subnets
  security_group_id     = module.test_client_instance_sg.security_group_id
}

data "template_file" "subscriber_template_file" {
  template = file("${path.module}/installation-dependencies/templates/test-subscribers-docker-startup-script.tmpl")
  vars = {
    sensor_1_address = var.test_instances_config.subscribers.startup_data_config.sensor_1.address
    entity_1_address = var.test_instances_config.subscribers.startup_data_config.sensor_1.entity_address
    entity_1_jwt     = var.test_instances_config.subscribers.startup_data_config.sensor_1.entity_jwt

    sensor_2_address = var.test_instances_config.subscribers.startup_data_config.sensor_2.address
    entity_2_address = var.test_instances_config.subscribers.startup_data_config.sensor_2.entity_address
    entity_2_jwt     = var.test_instances_config.subscribers.startup_data_config.sensor_2.entity_jwt

    sensor_3_address = var.test_instances_config.subscribers.startup_data_config.sensor_3.address
    entity_3_address = var.test_instances_config.subscribers.startup_data_config.sensor_3.entity_address
    entity_3_jwt     = var.test_instances_config.subscribers.startup_data_config.sensor_3.entity_jwt

    sensor_4_address = var.test_instances_config.subscribers.startup_data_config.sensor_4.address
    entity_4_address = var.test_instances_config.subscribers.startup_data_config.sensor_4.entity_address
    entity_4_jwt     = var.test_instances_config.subscribers.startup_data_config.sensor_4.entity_jwt

    sensor_5_address = var.test_instances_config.subscribers.startup_data_config.sensor_5.address
    entity_5_address = var.test_instances_config.subscribers.startup_data_config.sensor_5.entity_address
    entity_5_jwt     = var.test_instances_config.subscribers.startup_data_config.sensor_5.entity_jwt

    sensor_6_address = var.test_instances_config.subscribers.startup_data_config.sensor_6.address
    entity_6_address = var.test_instances_config.subscribers.startup_data_config.sensor_6.entity_address
    entity_6_jwt     = var.test_instances_config.subscribers.startup_data_config.sensor_6.entity_jwt

    sensor_7_address = var.test_instances_config.subscribers.startup_data_config.sensor_7.address
    entity_7_address = var.test_instances_config.subscribers.startup_data_config.sensor_7.entity_address
    entity_7_jwt     = var.test_instances_config.subscribers.startup_data_config.sensor_7.entity_jwt

    sensor_8_address = var.test_instances_config.subscribers.startup_data_config.sensor_8.address
    entity_8_address = var.test_instances_config.subscribers.startup_data_config.sensor_8.entity_address
    entity_8_jwt     = var.test_instances_config.subscribers.startup_data_config.sensor_8.entity_jwt

    sensor_9_address = var.test_instances_config.subscribers.startup_data_config.sensor_9.address
    entity_9_address = var.test_instances_config.subscribers.startup_data_config.sensor_9.entity_address
    entity_9_jwt     = var.test_instances_config.subscribers.startup_data_config.sensor_9.entity_jwt

    sensor_10_address = var.test_instances_config.subscribers.startup_data_config.sensor_10.address
    entity_10_address = var.test_instances_config.subscribers.startup_data_config.sensor_10.entity_address
    entity_10_jwt     = var.test_instances_config.subscribers.startup_data_config.sensor_10.entity_jwt


    sensor_11_address = var.test_instances_config.subscribers.startup_data_config.sensor_11.address
    entity_11_address = var.test_instances_config.subscribers.startup_data_config.sensor_11.entity_address
    entity_11_jwt     = var.test_instances_config.subscribers.startup_data_config.sensor_11.entity_jwt

    sensor_12_address = var.test_instances_config.subscribers.startup_data_config.sensor_12.address
    entity_12_address = var.test_instances_config.subscribers.startup_data_config.sensor_12.entity_address
    entity_12_jwt     = var.test_instances_config.subscribers.startup_data_config.sensor_12.entity_jwt

    sensor_13_address = var.test_instances_config.subscribers.startup_data_config.sensor_13.address
    entity_13_address = var.test_instances_config.subscribers.startup_data_config.sensor_13.entity_address
    entity_13_jwt     = var.test_instances_config.subscribers.startup_data_config.sensor_13.entity_jwt

    sensor_14_address = var.test_instances_config.subscribers.startup_data_config.sensor_14.address
    entity_14_address = var.test_instances_config.subscribers.startup_data_config.sensor_14.entity_address
    entity_14_jwt     = var.test_instances_config.subscribers.startup_data_config.sensor_14.entity_jwt

    sensor_15_address = var.test_instances_config.subscribers.startup_data_config.sensor_15.address
    entity_15_address = var.test_instances_config.subscribers.startup_data_config.sensor_15.entity_address
    entity_15_jwt     = var.test_instances_config.subscribers.startup_data_config.sensor_15.entity_jwt
  }
}