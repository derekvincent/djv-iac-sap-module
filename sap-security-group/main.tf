locals {

    security_group_name =  var.is_scs ? lower(join("-", [var.namespace, var.name, var.environment, "sap", var.sysnr, "scs", "sg"])) : lower(join("-", [var.namespace, var.name, var.environment, "sap", var.sysnr, "sg"]))

    ## 
    
    ## TAGS
    tag_name_env = join(":", [var.namespace, "environment"])
    tag_name_customer = join(":", [var.namespace, "customer"])
    tag_name_application = join(":", [var.namespace, "application"])

    common_tags = map(
        local.tag_name_env, var.environment,
        local.tag_name_customer, var.customer,
        local.tag_name_application, var.name,
    )
    abap_desc = join(" ", ["Base SAP ABAP Security Group for System Number: ", var.sysnr])
    scs_desc  = join(" ", ["Base SAP ABAP SCS Security Group for System Number: ", var.sysnr])
   
    sap_base_ports = [
        {
            from_port: join("",["32", var.sysnr]),
            to_port: join("",["32", var.sysnr]),
            protocol: "TCP",
            cidr_blocks: var.sap_base_cidr,
            prefix_ids : var.sap_base_prefix,
            description : "SAP Gui" 
        },
        {
            from_port: join("",["33", var.sysnr]),
            to_port: join("",["33", var.sysnr]),
            protocol: "TCP",
            cidr_blocks: var.sap_base_cidr,
            prefix_ids : var.sap_base_prefix,
            description : "SAP RFC" 
        },        
        {
            from_port: join("",["38", var.sysnr]),
            to_port: join("",["38", var.sysnr]),
            protocol: "TCP",
            cidr_blocks: var.sap_base_cidr,
            prefix_ids : var.sap_base_prefix,
            description : "SAP Gateway" 
        },
        {
            from_port: join("",["48", var.sysnr]),
            to_port: join("",["48", var.sysnr]),
            protocol: "TCP",
            cidr_blocks: var.sap_base_cidr,
            prefix_ids : var.sap_base_prefix,
            description : "SAP Secure Gateway" 
        }        
    ]

    sap_standard_http = var.enable_sap_standard_http ? [
        {
            from_port: join("",["80", var.sysnr]),
            to_port: join("",["80", var.sysnr]),
            protocol: "TCP",
            cidr_blocks: var.sap_base_cidr,
            prefix_ids : var.sap_base_prefix,
            description : "SAP ABAP HTTP" 
        },
        {
            from_port: join("",["443", var.sysnr]),
            to_port: join("",["443", var.sysnr]),
            protocol: "TCP",
            cidr_blocks: var.sap_base_cidr,
            prefix_ids : var.sap_base_prefix,
            description : "SAP ABAP HTTPS" 
        } 
    ] :[]

    sap_control = [         
    {
            from_port: join("",["5", var.sysnr, "13"]),
            to_port: join("",["5", var.sysnr, "13"]),
            protocol: "TCP",
            cidr_blocks: var.sap_control_cidr,
            prefix_ids : var.sap_control_prefix,
            description : "SAP Control HTTP" 
        },
        {
            from_port: join("",["5", var.sysnr, "14"]),
            to_port: join("",["5", var.sysnr, "14"]),
            protocol: "TCP",
            cidr_blocks: var.sap_control_cidr,
            prefix_ids : var.sap_control_prefix,
            description : "SAP Control HTTPS" 
        } 
    ]

    sap_scs_ms = var.is_scs ? [         
    {
            from_port: join("",["36", var.sysnr]),
            to_port: join("",["36", var.sysnr]),
            protocol: "TCP",
            cidr_blocks: var.sap_base_cidr,
            prefix_ids : var.sap_base_prefix,
            description : "SAP Message Server Port" 
        },
        {
            from_port: join("",["81", var.sysnr]),
            to_port: join("",["81", var.sysnr]),
            protocol: "TCP",
            cidr_blocks: var.sap_base_cidr,
            prefix_ids : var.sap_base_prefix,
            description : "SAP HTTP Message Server Port" 
        } 
    ] : []

    sap_router = [         
        {
            from_port: var.sap_router_sysnr,
            to_port: var.sap_router_sysnr,
            protocol: "TCP",
            cidr_blocks: var.sap_router_cidr,
            prefix_ids : var.sap_router_prefix,
            description : "SAP Router" 
        } 
    ]

    security_group_ingress_rules = concat(local.sap_base_ports, local.sap_standard_http, local.sap_control,
                                          local.sap_scs_ms, local.sap_router, var.additional_ingress_rules)

    security_group_egress_rules = concat(local.sap_router, local.sap_base_ports, var.additional_egress_rules)
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
    from_port         = lookup(local.security_group_ingress_rules[count.index], "from_port")
    to_port           = lookup(local.security_group_ingress_rules[count.index], "to_port")
    protocol          = lookup(local.security_group_ingress_rules[count.index], "protocol")
    cidr_blocks       = lookup(local.security_group_ingress_rules[count.index], "cidr_blocks", null)
    prefix_list_ids   = lookup(local.security_group_ingress_rules[count.index], "prefix_ids", null)
    description       = lookup(local.security_group_ingress_rules[count.index], "description", "")
    security_group_id = aws_security_group.default.id
}