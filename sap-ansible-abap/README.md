# SAP Ansible ABAP variable generator

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| block\_devices | A list of block devices that will be as a simple block device.<br>Example Format:<br>[<br> {<br>   name : "Software",<br>   device : "/dev/sdg",<br>   size : "100%FREE",<br>   mount : "/sybase/DAC/archive\_logs",<br>   fstype : "xfs"<br> },<br>] | <pre>list(object({<br>    name   = string<br>    device = string<br>    size   = string<br>    mount  = string<br>    fstype = string<br>  }))</pre> | `null` | no |
| domainname | The domain name of the SAP system. | `string` | n/a | yes |
| hostname | The short hostname of the SAP system. | `string` | n/a | yes |
| ip\_address | The IP addrress of the SAP system. | `string` | n/a | yes |
| json\_format | Output the file in a json format instead of YAML. | `bool` | `false` | no |
| reboot\_after\_patch | Reboot the system after the patching is done. | `bool` | `false` | no |
| saptrans\_efs | n/a | <pre>map(<br>    object({<br>      filesystem_id   = string<br>      filesystem_host = string<br>      filesystem_ip   = string<br>      tls : bool<br>      iam : bool<br>      access_point = string<br>    })<br>  )</pre> | `null` | no |
| sid | SID of the SAP system. | `string` | `""` | no |
| swap\_device | The EBS device to use for defined for swap (ie. /dev/sbw). | `string` | n/a | yes |
| volume\_groups | List of devices and volume groups to be created. | <pre>list(object({<br>    name    = string<br>    devices = list(string)<br>    logical_volumes = list(object({<br>      name   = string<br>      size   = string<br>      mount  = string<br>      fstype = string<br>    }))<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| template | The ansible variable template to use for an SAP ABAP base system. |
| template\_format | The format of the template generated. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->