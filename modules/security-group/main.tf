resource "aws_security_group" "security_group" {
  vpc_id      = var.vpc_id
  description = var.description
  name        = var.sg_name

  tags = merge(
    var.common_tags,
    map(
      "Description", var.description,
      "Name", var.sg_name,
      "Region", var.aws_region
    )
  )
}

resource "aws_security_group_rule" "allow_icmp" {
  count             = var.allow_icmp ? 1 : 0
  security_group_id = aws_security_group.security_group.id
  from_port         = 8
  to_port           = 0
  type              = "ingress"
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow-ping-from-everywhere"
}

resource "aws_security_group_rule" "ingress_source_sg_rule" {
  for_each                 = local.ingress_source_sg_rules_map
  security_group_id        = aws_security_group.security_group.id
  source_security_group_id = each.value.source_security_group
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  type                     = "ingress"
  protocol                 = each.value.protocol
  description              = each.key
}


resource "aws_security_group_rule" "ingress_cird_block_rule" {
  for_each          = var.ingress_cidr_block_rules
  security_group_id = aws_security_group.security_group.id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  type              = "ingress"
  cidr_blocks       = each.value.cidr_blocks
  description       = each.key
}

resource "aws_security_group_rule" "egress_source_sg_rule" {
  for_each                 = local.egress_source_sg_rules_map
  security_group_id        = aws_security_group.security_group.id
  source_security_group_id = each.value.source_security_group
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  type                     = "egress"
  protocol                 = each.value.protocol
  description              = each.key
}

resource "aws_security_group_rule" "egress_cird_block_rule" {
  for_each          = var.egress_cidr_block_rules
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  security_group_id = aws_security_group.security_group.id
  type              = "egress"
  cidr_blocks       = each.value.cidr_blocks
  description       = each.key
}