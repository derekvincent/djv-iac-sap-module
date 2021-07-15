# SAP Application Security Group Generator

This will generate a base security group for a CI, DI, and ASCS based SAP instaces. They group will be targeted based on the SAP system number input. Addtional ingress/egress rules are allowed to passed in. 

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
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_egress_rules"></a> [additional\_egress\_rules](#input\_additional\_egress\_rules) | Additional egress rules to add. <br>Example Format:<pre>[<br>    { <br>        from_port : 0, <br>        to_port : 0,<br>        protocol : "-1", <br>        cidr_blocks : ["10.100.0.0/16", "192.168.111.0/24", "192.168.99.0/24"],<br>        prefix_ids : [], <br>        security_group : "",<br>        description : "Ping from AWS and VPN subnets."<br>    },<br>  ]</pre> | `list(any)` | `[]` | no |
| <a name="input_additional_ingress_rules"></a> [additional\_ingress\_rules](#input\_additional\_ingress\_rules) | Additional ingress rules to add. <br>Example Format:<pre>[<br>    { <br>        from_port : 0, <br>        to_port : 0,<br>        protocol : "-1", <br>        cidr_blocks : ["10.100.0.0/16", "192.168.111.0/24", "192.168.99.0/24"],<br>        prefix_ids : [], <br>        security_group : "",<br>        description : "Ping from AWS and VPN subnets."<br>    },<br>  ]</pre> | `list(any)` | `[]` | no |
| <a name="input_customer"></a> [customer](#input\_customer) | Customer (internal/external) Name - billing tag | `string` | n/a | yes |
| <a name="input_enable_sap_standard_http"></a> [enable\_sap\_standard\_http](#input\_enable\_sap\_standard\_http) | Enable standard SAP http/s ports (80xx, and 443xx). | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment - used in tagging and name generation. | `string` | `""` | no |
| <a name="input_is_scs"></a> [is\_scs](#input\_is\_scs) | Is this security group for an ABAP SCS instance. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name or application - used in tagging and name generation | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace - used in tagging and name generation. | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_sap_base_cidr"></a> [sap\_base\_cidr](#input\_sap\_base\_cidr) | List of CIDR's to allow to common user accessed ports. | `list(any)` | `[]` | no |
| <a name="input_sap_base_prefix"></a> [sap\_base\_prefix](#input\_sap\_base\_prefix) | List of prefix list id's to allow to common user accessed ports | `list(any)` | `[]` | no |
| <a name="input_sap_control_cidr"></a> [sap\_control\_cidr](#input\_sap\_control\_cidr) | List of CIDR's to allow to the SAP Control process (start/stop etc). | `list(any)` | `[]` | no |
| <a name="input_sap_control_prefix"></a> [sap\_control\_prefix](#input\_sap\_control\_prefix) | List of Prefix List to allow to the SAP Control process (start/stop etc). | `list(any)` | `[]` | no |
| <a name="input_sap_router_cidr"></a> [sap\_router\_cidr](#input\_sap\_router\_cidr) | List of CIDRs to allow acces to/from SAP Router. | `list(any)` | `[]` | no |
| <a name="input_sap_router_prefix"></a> [sap\_router\_prefix](#input\_sap\_router\_prefix) | List of Preix List to allow acces to/from SAP Router. | `list(any)` | `[]` | no |
| <a name="input_sap_router_sysnr"></a> [sap\_router\_sysnr](#input\_sap\_router\_sysnr) | System number of the SAP router used. | `string` | `"3299"` | no |
| <a name="input_sysnr"></a> [sysnr](#input\_sysnr) | SAP System Number. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC the security group will be created in. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sysnr_security_group_map"></a> [sysnr\_security\_group\_map](#output\_sysnr\_security\_group\_map) | Map of the created security groups created keyed by the system number of the system number -<pre>scs</pre>if it is for the ASCS instance. Provides the Group ARN and ID. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->