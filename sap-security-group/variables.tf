variable "namespace" {
  description = "Namespace - used in tagging and name generation."
  type        = string
  default     = ""
}


variable "environment" {
  description = "Environment - used in tagging and name generation."
  type        = string
  default     = ""
}

variable "name" {
  description = "Name or application - used in tagging and name generation"
  type        = string
}

variable "customer" {
  description = "Customer (internal/external) Name - billing tag"
  type        = string
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "additional_ingress_rules" {
  description = <<-HEREDOC
  Additional ingress rules to add. 
  Example Format: 
  ```
    [
      { 
          from_port : 0, 
          to_port : 0,
          protocol : "-1", 
          cidr_blocks : ["10.100.0.0/16", "192.168.111.0/24", "192.168.99.0/24"],
          prefix_ids : [], 
          security_group : "",
          description : "Ping from AWS and VPN subnets."
      },
    ]
  ```
  HEREDOC
  type        = list(any)
  default     = []
}

variable "additional_egress_rules" {
  description = <<-HEREDOC
  Additional egress rules to add. 
  Example Format: 
  ```
    [
      { 
          from_port : 0, 
          to_port : 0,
          protocol : "-1", 
          cidr_blocks : ["10.100.0.0/16", "192.168.111.0/24", "192.168.99.0/24"],
          prefix_ids : [], 
          security_group : "",
          description : "Ping from AWS and VPN subnets."
      },
    ]
  ```
  HEREDOC
  type        = list(any)
  default     = []
}
variable "vpc_id" {
  description = "The ID of the VPC the security group will be created in."
  type        = string
}

variable "sysnr" {
  description = "SAP System Number."
  type        = string
}

variable "sap_base_cidr" {
  description = "List of CIDR's to allow to common user accessed ports."
  type        = list(any)
  default     = []
}

variable "sap_base_prefix" {
  description = "List of prefix list id's to allow to common user accessed ports"
  type        = list(any)
  default     = []
}

variable "enable_sap_standard_http" {
  description = "Enable standard SAP http/s ports (80xx, and 443xx)."
  type        = bool
  default     = true
}

variable "sap_control_cidr" {
  description = "List of CIDR's to allow to the SAP Control process (start/stop etc)."
  type        = list(any)
  default     = []
}

variable "sap_control_prefix" {
  description = "List of Prefix List to allow to the SAP Control process (start/stop etc)."
  type        = list(any)
  default     = []
}

variable "is_scs" {
  description = "Is this security group for an ABAP SCS instance."
  type        = bool
  default     = false
}


variable "sap_router_sysnr" {
  description = "System number of the SAP router used."
  type        = string
  default     = "3299"
}

variable "sap_router_cidr" {
  description = "List of CIDRs to allow acces to/from SAP Router."
  type        = list(any)
  default     = []
}

variable "sap_router_prefix" {
  description = "List of Preix List to allow acces to/from SAP Router."
  type        = list(any)
  default     = []
}
