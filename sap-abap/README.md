# SAP ABAP EC2 Instance Provisioning

Provisions an SAP EC2 instance based on a targeted single ABAP instance (ASCS/DI).

## Module Function

- Creation of instance security group 
- Attached general CI/ASCS security group that are provided
- EC2 Instance
- Defined EBS volumes with associsation to the above instance
- IAM Role for the instance that includes the following policies:
  - AmazonSSMManagedInstanceCore (Amazon)
  - CloudWatchAgentServerPolicy (Amazon)
  - AmazonElasticFileSystemsUtils (Amazon)
  - EFS Access to the provided EFS filesystem and Access Points
  - Parovided Shared Service assume for accessing additional resources such S3 buckets in local or cross-account

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
| additional\_security\_groups | Additional Security groups to add to the instance. | `list(any)` | `[]` | no |
| assumed\_shared\_roles | List of possible roles that the instance can assume. | `list(string)` | `[]` | no |
| customer | Customer (internal/external) Name - billing tag | `string` | n/a | yes |
| ebs\_disk\_layouts | Map of the additional ebs values to be added.<pre>{ <br>  "sdf" : {"type": "gp2", "size": 120, "encrypted": true, "description": "sap volume"},<br>  "sdh" : {"type": "gp2", "size": 200, "encrypted": true, "description": "db volume"},<br>  "sdm" : {"type": "gp2", "size": 150, "encrypted": true, "description": "backup"},<br>  "sdo" : {"type": "gp2", "size": 300, "encrypted": true, "description": "sltools"},   <br>}</pre> | `map(any)` | n/a | yes |
| ebs\_optimized | Enable the EBS optimization on the instance if support. | `bool` | `false` | no |
| ec2\_ami | AMI for the Instance being created. | `string` | n/a | yes |
| ec2\_instance\_type | EC2 Instance Type. | `string` | n/a | yes |
| ec2\_private\_ip | Sets the instances IP address. If not set then an IP from thee subnet ranging will be assigned. | `string` | `null` | no |
| efs\_access\_point | Map of the EFS access points avaliable. Keyed on system type identifier. | `map(any)` | `{}` | no |
| enable\_enhanced\_monitoring | Enable Enhanced Cloudwatch Monitoring. | `bool` | `true` | no |
| enable\_public\_address | Enable assignment of a public address when in a public subnet. | `bool` | `false` | no |
| environment | Environment - used in tagging and name generation. | `string` | `""` | no |
| fqdn | The fully qualified domain name to be used in the hostname tag. | `string` | `""` | no |
| hostname | Hostname for the instnace, omit the domain name as it will be applied as per the VPC. | `string` | n/a | yes |
| key\_name | An existing EC2 instance keypair to use. | `string` | n/a | yes |
| name | Name or application - used in tagging and name generation | `string` | n/a | yes |
| namespace | Namespace - used in tagging and name generation. | `string` | `""` | no |
| region | AWS region | `string` | `"us-east-1"` | no |
| root\_volume\_encrypted | Enable Root Volume Encryption. | `bool` | `true` | no |
| root\_volume\_size | Root Volume size. | `string` | `"20"` | no |
| root\_volume\_type | Root Volume type - standard, gp2, io1 or io2. | `string` | `"gp2"` | no |
| sap\_application | SAP Application being deployed - ie. ECC, S/4, BW, BW/4, CRM, GRC, EP, NW-ABAP. | `string` | n/a | yes |
| sap\_application\_version | The main SAP Application version - used in tagging. | `string` | n/a | yes |
| sap\_instance\_type | Type of SAP instance modes deployed on the host - ASCS, DIALOG | `string` | n/a | yes |
| sap\_netweaver\_version | Technical version of the underlying Netweaver stack - used in tagging. | `string` | n/a | yes |
| sap\_sid | SAP System ID. | `string` | n/a | yes |
| sap\_sysnr | SAP System Number. | `string` | n/a | yes |
| sap\_type | Type of SAP instance - ABAP, J2EE, HANA, WD. | `string` | `"ABAP"` | no |
| security\_group\_egress\_rules | Security group egress rules, default to allow everything.<br>Example Format:<pre>[<br>    { <br>        from_port : 0, <br>        to_port : 0,<br>        protocol : "-1", <br>        cidr_blocks : ["10.100.0.0/16", "192.168.111.0/24", "192.168.99.0/24"],<br>        prefix_ids : [], <br>        security_group : "",<br>        description : "Ping from AWS and VPN subnets."<br>    },<br>  ]</pre> | `list(any)` | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Allow everythig to everywhere.",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| security\_group\_ingress\_rules | Security group ingress rules, default to allow ICMP and SSH from everywhere.<br>Example Format:<pre>[<br>    { <br>        from_port : 0, <br>        to_port : 0,<br>        protocol : "-1", <br>        cidr_blocks : ["10.100.0.0/16", "192.168.111.0/24", "192.168.99.0/24"],<br>        prefix_ids : [], <br>        security_group : "",<br>        description : "Ping from AWS and VPN subnets."<br>    },<br>  ]</pre> | `list(any)` | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Allow ICMP from everywhere",<br>    "from_port": -1,<br>    "protocol": "icmp",<br>    "to_port": -1<br>  },<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Allow Ping from everywhere",<br>    "from_port": 22,<br>    "protocol": "tcp",<br>    "to_port": 22<br>  }<br>]</pre> | no |
| subnet\_id | VPC Subnet ID to deploy the instance into. | `string` | n/a | yes |
| swap\_volume\_encrypted | Enable Swap Volume Encryption. | `bool` | `true` | no |
| swap\_volume\_size | Swap Volume size. | `string` | n/a | yes |
| swap\_volume\_type | Swap Volume type - standard, gp2, io1 or io2. | `string` | `"standard"` | no |
| termination\_protection | Instance termination protection. IMPORTANT: This currently does not protect assigned EBS disk from `terraform destroy`. | `bool` | `true` | no |
| vpc\_id | The VPC ID where the system and related components will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance | n/a |
| instance\_role\_arn | n/a |
| instance\_role\_id | n/a |
| instance\_role\_name | n/a |
| instance\_security\_group\_arn | The arn of the security group created for the server. |
| instance\_security\_group\_id | The id of the security group created for the server. |
| instance\_security\_group\_name | The name of the security group created for the server. |
| swap\_device | The provisioned swap device name. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->