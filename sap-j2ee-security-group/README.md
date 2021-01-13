# SAP Application Security Group Generator

This will generate a base security group for a CI, DI, and ASCS based SAP instaces. They group will be targeted based on the SAP system number input. Addtional ingress/egress rules are allowed to passed in. 

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_egress\_rules | Additional egress rules to add. <br>Example Format:<pre>[<br>    { <br>        from_port : 0, <br>        to_port : 0,<br>        protocol : "-1", <br>        cidr_blocks : ["10.100.0.0/16", "192.168.111.0/24", "192.168.99.0/24"],<br>        prefix_ids : [], <br>        security_group : "",<br>        description : "Ping from AWS and VPN subnets."<br>    },<br>  ]</pre> | `list(any)` | `[]` | no |
| additional\_ingress\_rules | Additional ingress rules to add. <br>Example Format:<pre>[<br>    { <br>        from_port : 0, <br>        to_port : 0,<br>        protocol : "-1", <br>        cidr_blocks : ["10.100.0.0/16", "192.168.111.0/24", "192.168.99.0/24"],<br>        prefix_ids : [], <br>        security_group : "",<br>        description : "Ping from AWS and VPN subnets."<br>    },<br>  ]</pre> | `list(any)` | `[]` | no |
| customer | Customer (internal/external) Name - billing tag | `string` | n/a | yes |
| enable\_sap\_standard\_http | Enable standard SAP http/s ports (80xx, and 443xx). | `bool` | `true` | no |
| environment | Environment - used in tagging and name generation. | `string` | `""` | no |
| is\_scs | Is this security group for an ABAP SCS instance. | `bool` | `false` | no |
| name | Name or application - used in tagging and name generation | `string` | n/a | yes |
| namespace | Namespace - used in tagging and name generation. | `string` | `""` | no |
| region | AWS region | `string` | `"us-east-1"` | no |
| sap\_base\_cidr | List of CIDR's to allow to common user accessed ports. | `list(any)` | `[]` | no |
| sap\_base\_prefix | List of prefix list id's to allow to common user accessed ports | `list(any)` | `[]` | no |
| sap\_control\_cidr | List of CIDR's to allow to the SAP Control process (start/stop etc). | `list(any)` | `[]` | no |
| sap\_control\_prefix | List of Prefix List to allow to the SAP Control process (start/stop etc). | `list(any)` | `[]` | no |
| sap\_router\_cidr | List of CIDRs to allow acces to/from SAP Router. | `list(any)` | `[]` | no |
| sap\_router\_prefix | List of Preix List to allow acces to/from SAP Router. | `list(any)` | `[]` | no |
| sap\_router\_sysnr | System number of the SAP router used. | `string` | `"3299"` | no |
| sysnr | SAP System Number. | `string` | n/a | yes |
| vpc\_id | The ID of the VPC the security group will be created in. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| sysnr\_security\_group\_map | Map of the created security groups created keyed by the system number of the system number -<pre>scs</pre>if it is for the ASCS instance. Provides the Group ARN and ID. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->