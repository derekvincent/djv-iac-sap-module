${
  jsonencode(
    {
    "hostname": "${hostname}"
    "domainname": "${domainname}"
    "private_ip_address": "${ip_address}"
    "reboot_after_patch": "${reboot_after_patch}"
    "swap_device": "${swap_device}"

    "volume_groups" : "${volume_groups}"

    "block_devices" : "${block_devices}"

    "saptrans": "${saptrans}"
    }
  )
}