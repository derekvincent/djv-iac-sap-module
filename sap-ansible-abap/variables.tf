
variable "json_format" {
  description = "Output the file in a json format instead of YAML."
  type        = bool
  default     = false
}
variable "hostname" {
  description = "The short hostname of the SAP system."
  type        = string
}
variable "domainname" {
  description = "The domain name of the SAP system."
  type        = string
}

variable "ip_address" {
  description = "The IP addrress of the SAP system."
  type        = string
}

variable "sid" {
  description = "SID of the SAP system."
  type        = string
  default     = ""
}

variable "reboot_after_patch" {
  description = "Reboot the system after the patching is done."
  type        = bool
  default     = false
}

variable "swap_device" {
  description = "The EBS device to use for defined for swap (ie. /dev/sbw)."
  type        = string
}

variable "volume_groups" {
  description = "List of devices and volume groups to be created."
  type = list(object({
    name    = string
    devices = list(string)
    logical_volumes = list(object({
      name   = string
      size   = string
      mount  = string
      fstype = string
    }))
  }))
}

variable "block_devices" {
  description = <<-HEREDOC
    A list of block devices that will be as a simple block device.
    Example Format:  
    [
     {
       name : "Software",
       device : "/dev/sdg",
       size : "100%FREE",
       mount : "/sybase/DAC/archive_logs",
       fstype : "xfs"
     },
    ]
  HEREDOC

  type = list(object({
    name   = string
    device = string
    size   = string
    mount  = string
    fstype = string
  }))
  default = null
}

variable "saptrans_efs" {
  description = ""
  type = map(
    object({
      filesystem_id   = string
      filesystem_host = string
      filesystem_ip   = string
      tls : bool
      iam : bool
      access_point = string
    })
  )
  default = null
}