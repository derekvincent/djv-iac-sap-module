
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
  description = "SAP System ID."
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
  description = <<-HEREDOC
  Volume groups, logical volumes, files system types, sizes and mount points.
  Example Format:
  ```
  [
    {
      name : "sap",
      devices : ["/dev/sdf"],
      logical_volumes : [
        { name : "usr_sap", size : "50G", mount : "/usr/sap", fstype : "xfs" },
        { name : "sapmnt", size : "100%FREE", mount : "/sapmnt", fstype : "xfs" }
      ]
    },  
  ]
  ```
  HEREDOC
  type = list(
    object({
      name    = string
      devices = list(string)
      logical_volumes = list(
        object({
          name   = string
          size   = string
          mount  = string
          fstype = string
        })
      )
    })
  )
}

variable "block_devices" {
  description = <<-HEREDOC
    A list of block devices that will be as a simple block device.
    Example Format: 
    ``` 
    [
      {
        name : "Software",
        device : "/dev/sdg",
        size : "100%FREE",
        mount : "/sybase/DAC/archive_logs",
        fstype : "xfs"
      },
    ]
    ```
  HEREDOC

  type = list(
    object({
      name   = string
      device = string
      size   = string
      mount  = string
      fstype = string
    })
  )
  default = null
}

variable "saptrans_efs" {
  description = <<-HEREDOC
  SAP Transport EFS details.
  Example Format: 
  ```
  { 
    "use2-az1" : {
      filesystem_id : "fs-3df46f45"
      filesystem_host : "fs-3df46f45.efs.us-east-2.amazonaws.com"
      filesystem_ip : "10.100.12.25"
      tls : true
      iam : true
      access_point : "fsap-01230fe8d391ac5b6"
    } 
  }
  ```
  HEREDOC

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

variable "region" {
  description = "The AWS region."
  type        = string
}

variable "shared_s3_role_arn" {
  description = "The role arn that is used to acccess central s3 buckets in shared service account."
  type        = string
}

variable "sap_app_type" {
  description = "The application type being deployed. Used to control some installation specifics."
  type        = string
  default     = ""
}