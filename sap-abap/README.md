# SAP ABAP EC2 Instance Provisioning

Provisions an SAP EC2 instance based on a targeted single ABAP instance (ASCS/DI).

## Module Function

- Creation of instance security group 
- Attached general CI/ASCS security group that are provided
- EC2 Instance
- Defined EBS volumes with association to the above instance
- IAM Role for the instance that includes the following policies:
  - AmazonSSMManagedInstanceCore (Amazon)
  - CloudWatchAgentServerPolicy (Amazon)
  - AmazonElasticFileSystemsUtils (Amazon)
  - EFS Access to the provided EFS filesystem and Access Points
  - Provided Shared Service assume for accessing additional resources such S3 buckets in local or cross-account

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ebs_volume.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.swap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_iam_instance_profile.sap_abap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.sap_abap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.inline-policy-efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.inline-policy-sap-data-provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.inline-policy-shared-roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.efsutils](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.systems_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.sap-abap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_volume_attachment.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |
| [aws_volume_attachment.swap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |
| [aws_ec2_instance_type_offering.abap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_instance_type_offering) | data source |
| [aws_iam_policy_document.inline-policy-document-efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.inline-policy-document-sap-data-provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.inline-policy-document-shared-roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnet.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_security_groups"></a> [additional\_security\_groups](#input\_additional\_security\_groups) | Additional Security groups to add to the instance. | `list(any)` | `[]` | no |
| <a name="input_assumed_shared_roles"></a> [assumed\_shared\_roles](#input\_assumed\_shared\_roles) | List of possible roles that the instance can assume. | `list(string)` | `[]` | no |
| <a name="input_customer"></a> [customer](#input\_customer) | Customer (internal/external) Name - billing tag | `string` | n/a | yes |
| <a name="input_ebs_disk_layouts"></a> [ebs\_disk\_layouts](#input\_ebs\_disk\_layouts) | Map of the additional ebs values to be added.<pre>{ <br>  "sdf" : {"type": "gp2", "size": 120, "encrypted": true, "description": "sap volume"},<br>  "sdh" : {"type": "gp2", "size": 200, "encrypted": true, "description": "db volume"},<br>  "sdm" : {"type": "gp2", "size": 150, "encrypted": true, "description": "backup"},<br>  "sdo" : {"type": "gp2", "size": 300, "encrypted": true, "description": "sltools"},   <br>}</pre> | `map(any)` | n/a | yes |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | Enable the EBS optimization on the instance if support. | `bool` | `false` | no |
| <a name="input_ec2_ami"></a> [ec2\_ami](#input\_ec2\_ami) | AMI for the Instance being created. | `string` | n/a | yes |
| <a name="input_ec2_instance_type"></a> [ec2\_instance\_type](#input\_ec2\_instance\_type) | EC2 Instance Type. | `string` | n/a | yes |
| <a name="input_ec2_private_ip"></a> [ec2\_private\_ip](#input\_ec2\_private\_ip) | Sets the instances IP address. If not set then an IP from thee subnet ranging will be assigned. | `string` | `null` | no |
| <a name="input_efs_access_point"></a> [efs\_access\_point](#input\_efs\_access\_point) | Map of the EFS access points avaliable. Keyed on system type identifier. | `map(any)` | `{}` | no |
| <a name="input_enable_enhanced_monitoring"></a> [enable\_enhanced\_monitoring](#input\_enable\_enhanced\_monitoring) | Enable Enhanced Cloudwatch Monitoring. | `bool` | `true` | no |
| <a name="input_enable_public_address"></a> [enable\_public\_address](#input\_enable\_public\_address) | Enable assignment of a public address when in a public subnet. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment - used in tagging and name generation. | `string` | `""` | no |
| <a name="input_fqdn"></a> [fqdn](#input\_fqdn) | The fully qualified domain name to be used in the hostname tag. | `string` | `""` | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | Hostname for the instnace, omit the domain name as it will be applied as per the VPC. | `string` | n/a | yes |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | An existing EC2 instance keypair to use. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name or application - used in tagging and name generation | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace - used in tagging and name generation. | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_root_volume_encrypted"></a> [root\_volume\_encrypted](#input\_root\_volume\_encrypted) | Enable Root Volume Encryption. | `bool` | `true` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | Root Volume size. | `string` | `"20"` | no |
| <a name="input_root_volume_type"></a> [root\_volume\_type](#input\_root\_volume\_type) | Root Volume type - standard, gp2, io1 or io2. | `string` | `"gp2"` | no |
| <a name="input_sap_application"></a> [sap\_application](#input\_sap\_application) | SAP Application being deployed - ie. ECC, S/4, BW, BW/4, CRM, GRC, EP, NW-ABAP. | `string` | n/a | yes |
| <a name="input_sap_application_version"></a> [sap\_application\_version](#input\_sap\_application\_version) | The main SAP Application version - used in tagging. | `string` | n/a | yes |
| <a name="input_sap_instance_type"></a> [sap\_instance\_type](#input\_sap\_instance\_type) | Type of SAP instance modes deployed on the host - ASCS, DIALOG | `string` | n/a | yes |
| <a name="input_sap_netweaver_version"></a> [sap\_netweaver\_version](#input\_sap\_netweaver\_version) | Technical version of the underlying Netweaver stack - used in tagging. | `string` | n/a | yes |
| <a name="input_sap_sid"></a> [sap\_sid](#input\_sap\_sid) | SAP System ID. | `string` | n/a | yes |
| <a name="input_sap_sysnr"></a> [sap\_sysnr](#input\_sap\_sysnr) | SAP System Number. | `string` | n/a | yes |
| <a name="input_sap_type"></a> [sap\_type](#input\_sap\_type) | Type of SAP instance - ABAP, J2EE, HANA, WD. | `string` | `"ABAP"` | no |
| <a name="input_security_group_egress_rules"></a> [security\_group\_egress\_rules](#input\_security\_group\_egress\_rules) | Security group egress rules, default to allow everything.<br>Example Format:<pre>[<br>    { <br>        from_port : 0, <br>        to_port : 0,<br>        protocol : "-1", <br>        cidr_blocks : ["10.100.0.0/16", "192.168.111.0/24", "192.168.99.0/24"],<br>        prefix_ids : [], <br>        security_group : "",<br>        description : "Ping from AWS and VPN subnets."<br>    },<br>  ]</pre> | `list(any)` | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Allow everythig to everywhere.",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_security_group_ingress_rules"></a> [security\_group\_ingress\_rules](#input\_security\_group\_ingress\_rules) | Security group ingress rules, default to allow ICMP and SSH from everywhere.<br>Example Format:<pre>[<br>    { <br>        from_port : 0, <br>        to_port : 0,<br>        protocol : "-1", <br>        cidr_blocks : ["10.100.0.0/16", "192.168.111.0/24", "192.168.99.0/24"],<br>        prefix_ids : [], <br>        security_group : "",<br>        description : "Ping from AWS and VPN subnets."<br>    },<br>  ]</pre> | `list(any)` | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Allow ICMP from everywhere",<br>    "from_port": -1,<br>    "protocol": "icmp",<br>    "to_port": -1<br>  },<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Allow Ping from everywhere",<br>    "from_port": 22,<br>    "protocol": "tcp",<br>    "to_port": 22<br>  }<br>]</pre> | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | VPC Subnet ID to deploy the instance into. | `string` | n/a | yes |
| <a name="input_swap_volume_encrypted"></a> [swap\_volume\_encrypted](#input\_swap\_volume\_encrypted) | Enable Swap Volume Encryption. | `bool` | `true` | no |
| <a name="input_swap_volume_size"></a> [swap\_volume\_size](#input\_swap\_volume\_size) | Swap Volume size. | `string` | n/a | yes |
| <a name="input_swap_volume_type"></a> [swap\_volume\_type](#input\_swap\_volume\_type) | Swap Volume type - standard, gp2, io1 or io2. | `string` | `"standard"` | no |
| <a name="input_termination_protection"></a> [termination\_protection](#input\_termination\_protection) | Instance termination protection. IMPORTANT: This currently does not protect assigned EBS disk from `terraform destroy`. | `bool` | `true` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID where the system and related components will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance"></a> [instance](#output\_instance) | n/a |
| <a name="output_instance_role_arn"></a> [instance\_role\_arn](#output\_instance\_role\_arn) | n/a |
| <a name="output_instance_role_id"></a> [instance\_role\_id](#output\_instance\_role\_id) | n/a |
| <a name="output_instance_role_name"></a> [instance\_role\_name](#output\_instance\_role\_name) | n/a |
| <a name="output_instance_security_group_arn"></a> [instance\_security\_group\_arn](#output\_instance\_security\_group\_arn) | The arn of the security group created for the server. |
| <a name="output_instance_security_group_id"></a> [instance\_security\_group\_id](#output\_instance\_security\_group\_id) | The id of the security group created for the server. |
| <a name="output_instance_security_group_name"></a> [instance\_security\_group\_name](#output\_instance\_security\_group\_name) | The name of the security group created for the server. |
| <a name="output_swap_device"></a> [swap\_device](#output\_swap\_device) | The provisioned swap device name. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->