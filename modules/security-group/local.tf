locals {
  ingress_source_sg_rules = flatten([for description, object in var.ingress_source_sg_rules : [
    for source_sg_name, source_sg_id in object.source_security_groups : {
      from_port             = object.from_port
      to_port               = object.to_port
      protocol              = object.protocol
      source_security_group = source_sg_id
      description           = format("%s-%s", description, source_sg_name)
    }
  ]])
  ingress_source_sg_rules_map = {
    for k, v in local.ingress_source_sg_rules :
    v.description => {
      from_port             = v.from_port
      to_port               = v.to_port
      protocol              = v.protocol
      source_security_group = v.source_security_group
    }
  }

  egress_source_sg_rules = flatten([for description, object in var.egress_source_sg_rules : [
    for source_sg_name, source_sg_id in object.source_security_groups : {
      from_port             = object.from_port
      to_port               = object.to_port
      protocol              = object.protocol
      source_security_group = source_sg_id
      description           = format("%s-%s", description, source_sg_name)
    }
  ]])
  egress_source_sg_rules_map = {
    for k, v in local.egress_source_sg_rules :
    v.description => {
      from_port             = v.from_port
      to_port               = v.to_port
      protocol              = v.protocol
      source_security_group = v.source_security_group
    }
  }
}