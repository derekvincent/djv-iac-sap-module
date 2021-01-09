# SAP Ansible ABAP variable generator

This module is used to generate the variable file that is used to in the ansible playbook `sap-abap-build` and called from the SAP ABAP terraform deployments to setup the following: 
- Hostname, domain name and IP Address information 
- Logical Volume based disk layouts
- Block Device disk layout 
- Swap 
- SAP Trans EFS mounting 

***NOTE: If `[SID]` (literal with square brackets) is passed in along with the `sid` variable on the `volume_groups` or `block_devices` a value subtitution will be done. ***

It provides the output variable output as a YAML or Json string. 

## Testing

In the test folder is a simple test setup that can run. The variables are defined in the main.tf file. 

```bash
terraform init 
terraform apply 
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| block\_devices | A list of block devices that will be as a simple block device.<br>Example Format:<pre>[<br>  {<br>    name : "Software",<br>    device : "/dev/sdg",<br>    size : "100%FREE",<br>    mount : "/sybase/DAC/archive_logs",<br>    fstype : "xfs"<br>  },<br>]</pre> | <pre>list(<br>    object({<br>      name   = string<br>      device = string<br>      size   = string<br>      mount  = string<br>      fstype = string<br>    })<br>  )</pre> | `null` | no |
| domainname | The domain name of the SAP system. | `string` | n/a | yes |
| hostname | The short hostname of the SAP system. | `string` | n/a | yes |
| ip\_address | The IP addrress of the SAP system. | `string` | n/a | yes |
| json\_format | Output the file in a json format instead of YAML. | `bool` | `false` | no |
| reboot\_after\_patch | Reboot the system after the patching is done. | `bool` | `false` | no |
| region | The AWS region. | `string` | n/a | yes |
| saptrans\_efs | SAP Transport EFS details.<br>Example Format:<pre>{ <br>  "use2-az1" : {<br>    filesystem_id : "fs-3df46f45"<br>    filesystem_host : "fs-3df46f45.efs.us-east-2.amazonaws.com"<br>    filesystem_ip : "10.100.12.25"<br>    tls : true<br>    iam : true<br>    access_point : "fsap-01230fe8d391ac5b6"<br>  } <br>}</pre> | <pre>map(<br>    object({<br>      filesystem_id   = string<br>      filesystem_host = string<br>      filesystem_ip   = string<br>      tls : bool<br>      iam : bool<br>      access_point = string<br>    })<br>  )</pre> | `null` | no |
| shared\_s3\_role\_arn | The role arn that is used to acccess central s3 buckets in shared service account. | `string` | n/a | yes |
| sid | SAP System ID. | `string` | `""` | no |
| swap\_device | The EBS device to use for defined for swap (ie. /dev/sbw). | `string` | n/a | yes |
| volume\_groups | Volume groups, logical volumes, files system types, sizes and mount points.<br>Example Format:<pre>[<br>  {<br>    name : "sap",<br>    devices : ["/dev/sdf"],<br>    logical_volumes : [<br>      { name : "usr_sap", size : "50G", mount : "/usr/sap", fstype : "xfs" },<br>      { name : "sapmnt", size : "100%FREE", mount : "/sapmnt", fstype : "xfs" }<br>    ]<br>  },  <br>]</pre> | <pre>list(<br>    object({<br>      name    = string<br>      devices = list(string)<br>      logical_volumes = list(<br>        object({<br>          name   = string<br>          size   = string<br>          mount  = string<br>          fstype = string<br>        })<br>      )<br>    })<br>  )</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| template | The ansible variable template to use for an SAP ABAP base system. |
| template\_format | The format of the template generated. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->