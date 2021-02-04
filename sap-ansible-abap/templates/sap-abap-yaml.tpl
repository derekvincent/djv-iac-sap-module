${
  yamlencode(
    {
    "hostname": "${hostname}"
    "domainname": "${domainname}"
    "private_ip_address": "${ip_address}"
    "reboot_after_patch": "${reboot_after_patch}"
    "swap_device": "${swap_device}"
    "volume_groups" : "${volume_groups}"
    "block_devices" : "${block_devices}"
    "saptrans": "${saptrans}"
    "region": "${region}"
    "shared_s3_role_arn": "${shared_s3_role_arn}"
    "sap_app_type" : "${sap_app_type}"
    }
  )
}