locals {

  security_group_name = var.is_scs ? lower(join("-", [var.namespace, var.name, var.environment, "sap", "j2ee", var.sysnr, "scs", "sg"])) : lower(join("-", [var.namespace, var.name, var.environment, "sap", "j2ee", var.sysnr, "sg"]))

  ## 

  ## TAGS
  tag_name_env         = join(":", [var.namespace, "environment"])
  tag_name_customer    = join(":", [var.namespace, "customer"])
  tag_name_application = join(":", [var.namespace, "application"])

  common_tags = map(
    local.tag_name_env, var.environment,
    local.tag_name_customer, var.customer,
    local.tag_name_application, var.name,
  )
  abap_desc = join(" ", ["Base SAP J2EE Security Group for System Number: ", var.sysnr])
  scs_desc  = join(" ", ["Base SAP J2EE SCS Security Group for System Number: ", var.sysnr])

  sap_base_ports = [
    {
      from_port : join("", ["5", var.sysnr, "00"]),
      to_port : join("", ["5", var.sysnr, "04"]),
      protocol : "TCP",
      cidr_blocks : var.sap_base_cidr,
      prefix_ids : var.sap_base_prefix,
      description : "SAP J2EE: 00 HTTP, 01 HTTPS, 02 IIOP inital context, 03 IIOP over SSL, 04 P4"
    },
    {
      from_port : join("", ["5", var.sysnr, "06"]),
      to_port : join("", ["5", var.sysnr, "08"]),
      protocol : "TCP",
      cidr_blocks : var.sap_base_cidr,
      prefix_ids : var.sap_base_prefix,
      description : "SAP J2EE: 06 P4 over SSL, 07 IIOP, 07 Telnet"
    }
  ]

  sap_control = [
    {
      from_port : join("", ["5", var.sysnr, "13"]),
      to_port : join("", ["5", var.sysnr, "13"]),
      protocol : "TCP",
      cidr_blocks : var.sap_control_cidr,
      prefix_ids : var.sap_control_prefix,
      description : "SAP Control HTTP"
    },
    {
      from_port : join("", ["5", var.sysnr, "14"]),
      to_port : join("", ["5", var.sysnr, "14"]),
      protocol : "TCP",
      cidr_blocks : var.sap_control_cidr,
      prefix_ids : var.sap_control_prefix,
      description : "SAP Control HTTPS"
    }
  ]

  sap_scs_ms = var.is_scs ? [
    {
      from_port : join("", ["36", var.sysnr]),
      to_port : join("", ["36", var.sysnr]),
      protocol : "TCP",
      cidr_blocks : var.sap_base_cidr,
      prefix_ids : var.sap_base_prefix,
      description : "SAP Message Server Port"
    },
    {
      from_port : join("", ["81", var.sysnr]),
      to_port : join("", ["81", var.sysnr]),
      protocol : "TCP",
      cidr_blocks : var.sap_base_cidr,
      prefix_ids : var.sap_base_prefix,
      description : "SAP HTTP Message Server Port"
    }
  ] : []

  sap_router = [
    {
      from_port : var.sap_router_sysnr,
      to_port : var.sap_router_sysnr,
      protocol : "TCP",
      cidr_blocks : var.sap_router_cidr,
      prefix_ids : var.sap_router_prefix,
      description : "SAP Router"
    }
  ]

  security_group_ingress_rules = concat(local.sap_base_ports, local.sap_control,
  local.sap_scs_ms, local.sap_router, var.additional_ingress_rules)

  security_group_egress_rules = concat(local.sap_base_ports, local.sap_router, var.additional_egress_rules)
}


resource "aws_security_group" "default" {
  name        = local.security_group_name
  description = var.is_scs ? local.scs_desc : local.abap_desc
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    map(
      "Name", local.security_group_name
    )
  )
}

resource "aws_security_group_rule" "ingress" {
  count             = length(local.security_group_ingress_rules)
  type              = "ingress"
  from_port         = lookup(local.security_group_ingress_rules[count.index], "from_port")
  to_port           = lookup(local.security_group_ingress_rules[count.index], "to_port")
  protocol          = lookup(local.security_group_ingress_rules[count.index], "protocol")
  cidr_blocks       = lookup(local.security_group_ingress_rules[count.index], "cidr_blocks", null)
  prefix_list_ids   = lookup(local.security_group_ingress_rules[count.index], "prefix_ids", null)
  description       = lookup(local.security_group_ingress_rules[count.index], "description", "")
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "egress" {
  count             = length(local.security_group_egress_rules)
  type              = "egress"
  from_port         = lookup(local.security_group_egress_rules[count.index], "from_port")
  to_port           = lookup(local.security_group_egress_rules[count.index], "to_port")
  protocol          = lookup(local.security_group_egress_rules[count.index], "protocol")
  cidr_blocks       = lookup(local.security_group_egress_rules[count.index], "cidr_blocks", null)
  prefix_list_ids   = lookup(local.security_group_egress_rules[count.index], "prefix_ids", null)
  description       = lookup(local.security_group_egress_rules[count.index], "description", "")
  security_group_id = aws_security_group.default.id
}