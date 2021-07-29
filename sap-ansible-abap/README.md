# SAP Ansible ABAP variable generator

This module is used to generate the variable file that is used to in the ansible playbook `sap-abap-build` and called from the SAP ABAP terraform deployments to setup the following: 
- Hostname, domain name and IP Address information 
- Logical Volume based disk layouts
- Block Device disk layout 
- Swap 
- SAP Trans EFS mounting 
- Hugepages sizes 

***NOTE: If `[SID]` (literal with square brackets) is passed in along with the `sid` variable on the `volume_groups` or `block_devices` a value substitution will be done. ***

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

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_block_devices"></a> [block\_devices](#input\_block\_devices) | A list of block devices that will be as a simple block device.<br>Example Format:<pre>[<br>  {<br>    name : "Software",<br>    device : "/dev/sdg",<br>    size : "100%FREE",<br>    mount : "/sybase/DAC/archive_logs",<br>    fstype : "xfs"<br>  },<br>]</pre> | <pre>list(<br>    object({<br>      name   = string<br>      device = string<br>      size   = string<br>      mount  = string<br>      fstype = string<br>    })<br>  )</pre> | `null` | no |
| <a name="input_domainname"></a> [domainname](#input\_domainname) | The domain name of the SAP system. | `string` | n/a | yes |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | The short hostname of the SAP system. | `string` | n/a | yes |
| <a name="input_hugepages_size"></a> [hugepages\_size](#input\_hugepages\_size) | If using hugepages for the DB set the size to be used. | `number` | `0` | no |
| <a name="input_ip_address"></a> [ip\_address](#input\_ip\_address) | The IP addrress of the SAP system. | `string` | n/a | yes |
| <a name="input_json_format"></a> [json\_format](#input\_json\_format) | Output the file in a json format instead of YAML. | `bool` | `false` | no |
| <a name="input_reboot_after_patch"></a> [reboot\_after\_patch](#input\_reboot\_after\_patch) | Reboot the system after the patching is done. | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region. | `string` | n/a | yes |
| <a name="input_sap_app_type"></a> [sap\_app\_type](#input\_sap\_app\_type) | The application type being deployed. Used to control some installation specifics. | `string` | `""` | no |
| <a name="input_saptrans_efs"></a> [saptrans\_efs](#input\_saptrans\_efs) | SAP Transport EFS details.<br>Example Format:<pre>{ <br>  "use2-az1" : {<br>    filesystem_id : "fs-3df46f45"<br>    filesystem_host : "fs-3df46f45.efs.us-east-2.amazonaws.com"<br>    filesystem_ip : "10.100.12.25"<br>    tls : true<br>    iam : true<br>    access_point : "fsap-01230fe8d391ac5b6"<br>  } <br>}</pre> | <pre>map(<br>    object({<br>      filesystem_id   = string<br>      filesystem_host = string<br>      filesystem_ip   = string<br>      tls : bool<br>      iam : bool<br>      access_point = string<br>    })<br>  )</pre> | `null` | no |
| <a name="input_shared_s3_role_arn"></a> [shared\_s3\_role\_arn](#input\_shared\_s3\_role\_arn) | The role arn that is used to acccess central s3 buckets in shared service account. | `string` | n/a | yes |
| <a name="input_sid"></a> [sid](#input\_sid) | SAP System ID. | `string` | `""` | no |
| <a name="input_swap_device"></a> [swap\_device](#input\_swap\_device) | The EBS device to use for defined for swap (ie. /dev/sbw). | `string` | n/a | yes |
| <a name="input_volume_groups"></a> [volume\_groups](#input\_volume\_groups) | Volume groups, logical volumes, files system types, sizes and mount points.<br>Example Format:<pre>[<br>  {<br>    name : "sap",<br>    devices : ["/dev/sdf"],<br>    logical_volumes : [<br>      { name : "usr_sap", size : "50G", mount : "/usr/sap", fstype : "xfs" },<br>      { name : "sapmnt", size : "100%FREE", mount : "/sapmnt", fstype : "xfs" }<br>    ]<br>  },  <br>]</pre> | <pre>list(<br>    object({<br>      name    = string<br>      devices = list(string)<br>      logical_volumes = list(<br>        object({<br>          name   = string<br>          size   = string<br>          mount  = string<br>          fstype = string<br>        })<br>      )<br>    })<br>  )</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_template"></a> [template](#output\_template) | The ansible variable template to use for an SAP ABAP base system. |
| <a name="output_template_format"></a> [template\_format](#output\_template\_format) | The format of the template generated. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->