locals {

  instance_name    = lower(join("-", [var.namespace, var.name, var.environment, var.sap_application, var.sap_sid]))
  instance_sg_name = lower(join("-", [var.namespace, var.name, var.environment, var.sap_application, var.sap_sid, "sg"]))
  sap_dp_poicy_name = lower(join("-", [var.namespace, var.name, var.environment, "sap-data-provider-policy"]))

  swap_device = "/dev/sdw"
  ## 

  ## TAGS
  tag_name_env         = join(":", [var.namespace, "environment"])
  tag_name_customer    = join(":", [var.namespace, "customer"])
  tag_name_application = join(":", [var.namespace, "application"])
  tag_name_hostname    = join(":", [var.namespace, "hostname"])
  ## SAP Specifics
  tag_name_sap_type          = join(":", [var.namespace, "sap", "type"])
  tag_name_sap_app           = join(":", [var.namespace, "sap", "application"])
  tag_name_sap_version       = join(":", [var.namespace, "sap", "application", "version"])
  tag_name_sap_nw_version    = join(":", [var.namespace, "sap", "netweaver", "version"])
  tag_name_sap_instance_type = join(":", [var.namespace, "sap", "instance_type"])
  tag_name_sap_sid           = join(":", [var.namespace, "sap", "sid"])
  tag_name_sap_sysnr         = join(":", [var.namespace, "sap", "sysnr"])

  common_tags = map(
    local.tag_name_env, var.environment,
    local.tag_name_customer, var.customer,
    local.tag_name_application, var.name,
  )
  sap_tags = map(
    local.tag_name_sap_type, var.sap_type,
    local.tag_name_sap_app, var.sap_application,
    local.tag_name_sap_version, var.sap_application_version,
    local.tag_name_sap_nw_version, var.sap_netweaver_version,
    local.tag_name_sap_instance_type, var.sap_instance_type,
    local.tag_name_sap_sid, var.sap_sid,
    local.tag_name_sap_sysnr, var.sap_sysnr
  )

  security_groups = concat(list(aws_security_group.default.id), var.additional_security_groups)
}



data "aws_ec2_instance_type_offering" "abap" {
  filter {
    name   = "instance-type"
    values = [var.ec2_instance_type]
  }
}

##
## IAM Policies and Roles 
##

##
## Security Group 
##

resource "aws_security_group" "default" {
  name        = local.instance_sg_name
  description = join(" ", ["SAP ABAP system", var.sap_sid, "on host", var.hostname])
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    map(
      "Name", local.instance_sg_name
    )
  )
}

##
## Egress/Ingress Security Group rules 
##
## The inbound rules should be formatted as follows:
##    [{ 
##         from_port       :  3200,
##         to_port         : 3200,
##         protocol        :  "tcp",
##         cidr_blocks     : ["192.168.111.0/24", "192.168.99.0/24"],
##         prefix_ids      : ["pl-086fbfc43e011e9a8"],
##         security_groups : [],
##         description     : "SAP RFC from AWS and VPN subnets."
##     }]
##
## Cidrs, Prefix Lists, and [Security groups: issue] can be mixed and matched. 
## If not using one then an empty list needs to be passed in. 
##

resource "aws_security_group_rule" "egress" {
  count           = length(var.security_group_egress_rules)
  type            = "egress"
  from_port       = lookup(var.security_group_egress_rules[count.index], "from_port")
  to_port         = lookup(var.security_group_egress_rules[count.index], "to_port")
  protocol        = lookup(var.security_group_egress_rules[count.index], "protocol")
  cidr_blocks     = lookup(var.security_group_egress_rules[count.index], "cidr_blocks", null)
  prefix_list_ids = lookup(var.security_group_egress_rules[count.index], "prefix_ids", null)
  #    security_groups   = lookup(var.security_group_egress_rules[count.index], "security_groups", null)
  description       = lookup(var.security_group_egress_rules[count.index], "description", "")
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "ingress" {
  count           = length(var.security_group_ingress_rules)
  type            = "ingress"
  from_port       = lookup(var.security_group_ingress_rules[count.index], "from_port")
  to_port         = lookup(var.security_group_ingress_rules[count.index], "to_port")
  protocol        = lookup(var.security_group_ingress_rules[count.index], "protocol")
  cidr_blocks     = lookup(var.security_group_ingress_rules[count.index], "cidr_blocks", null)
  prefix_list_ids = lookup(var.security_group_ingress_rules[count.index], "prefix_ids", null)
  #    security_groups   = lookup(var.security_group_ingress_rules[count.index], "security_groups", null)
  description       = lookup(var.security_group_ingress_rules[count.index], "description", "")
  security_group_id = aws_security_group.default.id
}

##
## Create EC2 Instance 
##

resource "aws_instance" "sap-abap" {
  ami                         = var.ec2_ami
  instance_type               = var.ec2_instance_type
  iam_instance_profile        = aws_iam_instance_profile.sap_abap.name
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = local.security_groups
  monitoring                  = var.enable_enhanced_monitoring
  associate_public_ip_address = var.enable_public_address
  private_ip                  = var.ec2_private_ip
  disable_api_termination     = var.termination_protection
  ebs_optimized               = var.ebs_optimized

  root_block_device {
    volume_type = var.root_volume_type
    volume_size = var.root_volume_size
    encrypted   = var.root_volume_encrypted
  }

  tags = merge(
    local.common_tags,
    local.sap_tags,
    map(
      "Name", local.instance_name,
      local.tag_name_hostname, var.fqdn,
    )
  )
}

data "aws_subnet" "default" {
  id = var.subnet_id
}


##
## SWAP EBS is always required on an SAP ABAP instance so it will be explicitly crreated. 
##
resource "aws_ebs_volume" "swap" {
  availability_zone = data.aws_subnet.default.availability_zone
  size              = var.swap_volume_size
  type              = var.swap_volume_type
  encrypted         = var.swap_volume_encrypted

  tags = merge(
    local.common_tags,
    local.sap_tags,
    map(
      "Name", local.instance_name,
      join(":", [var.namespace, "ebs", "usage"]), "swap",
      join(":", [var.namespace, "ebs", "attachment"]), "/dev/sdw"
    )
  )
}

resource "aws_volume_attachment" "swap" {
  device_name = "/dev/sdw"
  volume_id   = aws_ebs_volume.swap.id
  instance_id = aws_instance.sap-abap.id
}

##
## Additional EBS disk as per the ebs_disk_layouts map
##
resource "aws_ebs_volume" "default" {
  for_each          = var.ebs_disk_layouts
  availability_zone = data.aws_subnet.default.availability_zone
  size              = each.value["size"]
  type              = each.value["type"]
  encrypted         = each.value["encrypted"]

  tags = merge(
    local.common_tags,
    local.sap_tags,
    map(
      "Name", local.instance_name,
      join(":", [var.namespace, "ebs", "usage"]), each.value["description"],
      join(":", [var.namespace, "ebs", "attachment"]), join("/", ["/dev", each.key])
    )
  )
}

resource "aws_volume_attachment" "default" {
  for_each    = var.ebs_disk_layouts
  device_name = join("/", ["/dev", each.key])
  volume_id   = aws_ebs_volume.default[each.key].id
  instance_id = aws_instance.sap-abap.id
}

##
## Create EC2 Instance roles, attach standard policies and profiles. 
##

## Create a Role for the EC2 instance
resource "aws_iam_role" "sap_abap" {
  name = join("-", [local.instance_name, "role"])

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : {
      "Effect" : "Allow",
      "Principal" : { "Service" : "ec2.amazonaws.com" },
      "Action" : "sts:AssumeRole"
    }
  })

  tags = merge(
    local.common_tags,
    map(
      "Name", join("-", [local.instance_name, "role"]),
      local.tag_name_sap_app, var.sap_application,
      local.tag_name_sap_sid, var.sap_sid
    )
  )
}

# Assign the SSM policy to the role
resource "aws_iam_role_policy_attachment" "systems_manager" {
  role       = aws_iam_role.sap_abap.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

## Assign the CloudWatch policy to the role
resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.sap_abap.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

## Assign the CloudWatch policy to the role
resource "aws_iam_role_policy_attachment" "efsutils" {
  role       = aws_iam_role.sap_abap.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemsUtils"
}

## Create an Instance Profile for the Role
resource "aws_iam_instance_profile" "sap_abap" {
  name = join("-", [local.instance_name, "role"])
  role = aws_iam_role.sap_abap.name
}

##
## Create an line policy and attach it to the role for the Shared Service assume roles
##

## Attach the inline policy to the role. 
resource "aws_iam_role_policy" "inline-policy-shared-roles" {
  count  = length(var.assumed_shared_roles) == 0 ? 0 : 1
  name   = join("-", [local.instance_name, "assumed-shared-roles"])
  role   = aws_iam_role.sap_abap.name
  policy = data.aws_iam_policy_document.inline-policy-document-shared-roles[count.index].json
}

## Create the Inline policy 
data "aws_iam_policy_document" "inline-policy-document-shared-roles" {

  count = length(var.assumed_shared_roles) == 0 ? 0 : 1
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]

    resources = var.assumed_shared_roles
  }
}


## Create and inline policy for supper of the AWS SAP Data Provider and attached it to the instance role.
resource "aws_iam_role_policy" "inline-policy-sap-data-provider" {
  name = local.sap_dp_poicy_name
  role = aws_iam_role.sap_abap.name
  policy = data.aws_iam_policy_document.inline-policy-document-sap-data-provider.json
}

data "aws_iam_policy_document" "inline-policy-document-sap-data-provider" {

  statement {
    effect = "Allow"
    actions = [
                "EC2:DescribeInstances",
                "cloudwatch:GetMetricStatistics",
                "EC2:DescribeVolumes"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::aws-sap-data-provider/config.properties"]
  }
}
##
## Create an line policy and attach it to the role for the EFS accesspoint access
##

## Attach the inline policy to the role. 
resource "aws_iam_role_policy" "inline-policy-efs" {
  # count   = var.efs_access_point.access_point != [] ? 0 : 1
  for_each = var.efs_access_point
  #name    = join("-", [local.instance_name, "efs-policy"])
  name = join("-", [each.value.tags.Name, "efs-policy"])
  role = aws_iam_role.sap_abap.name
  # policy  = data.aws_iam_policy_document.inline-policy-document-efs[count.index].json
  policy = data.aws_iam_policy_document.inline-policy-document-efs[each.key].json
}

## Create the Inline policy 
data "aws_iam_policy_document" "inline-policy-document-efs" {

  # count   = var.efs_access_point.access_point != [] ? 0 : 1
  for_each = var.efs_access_point
  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:DescribeMountTargets"
    ]

    resources = [
      each.value.arn,
      each.value.file_system_arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientRootAccess",
      "elasticfilesystem:ClientWrite",
    ]

    resources = [each.value.file_system_arn]

    condition {
      test     = "StringEquals"
      variable = "elasticfilesystem:AccessPointArn"
      values   = [each.value.arn]
    }
  }
  # statement {
  #     effect = "Allow"
  #     actions = [
  #         "elasticfilesystem:DescribeMountTargets"
  #     ]

  #     resources = [
  #         "${var.efs_access_point.access_point.arn}",
  #         "${var.efs_access_point.access_point.file_system_arn}"
  #     ]
  # }

  # statement {
  #     effect = "Allow"
  #     actions = [
  #             "elasticfilesystem:ClientMount",
  #             "elasticfilesystem:ClientRootAccess",
  #             "elasticfilesystem:ClientWrite",
  #     ]

  #     resources = "${var.efs_access_point.access_point.file_system_arn}"

  #     condition {
  #         test     = "StringEquals"
  #         variable = "elasticfilesystem:AccessPointArn"
  #         values   = "${var.efs_access_point.access_point.arn}"
  #     }
  # }   
}
