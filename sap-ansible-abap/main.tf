

locals {

  template_type = var.json_format ? "json" : "yaml"
  # template_name = concat(".", [concat("-", ["sap-abp", local.template_type]), "tpl"])

  ## Dirty dirty... convert to yaml (string) do a replace on the [SID] variable and 
  ## convert it back from yaml as a TF object. 
  volume_groups = yamldecode(replace(yamlencode(var.volume_groups), "[SID]", var.sid))
  block_devices = yamldecode(replace(yamlencode(var.block_devices), "[SID]", var.sid))
  template_name = "sap-abap-${local.template_type}.tpl"
  template_input = {
    hostname : var.hostname
    domainname : var.domainname
    ip_address : var.ip_address
    reboot_after_patch : var.reboot_after_patch
    swap_device : var.swap_device
    volume_groups : local.volume_groups
    block_devices : local.block_devices
    saptrans : var.saptrans_efs
    region : var.region
    shared_s3_role_arn : var.shared_s3_role_arn
    sap_app_type : var.sap_app_type
    hugepages_size : var.hugepages_size
  }

  template = templatefile("${path.module}/templates/${local.template_name}", local.template_input)
}
