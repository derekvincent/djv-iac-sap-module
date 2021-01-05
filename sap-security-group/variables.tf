variable "namespace" {
  description = "Namespace - 'clk' or 'clklab' "
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment - eg. 'sbx', 'dev','qa','prod'"
  type        = string
  default     = ""
}

variable "name" {
  description = "Name"
  type        = string
}

variable "customer" {
  description = "Customer Name - billing tag"
  type        = string
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "additional_ingress_rules" {
  description = "List of Map ingress rules "
  type        = list(any)
  default     = []
}

variable "additional_egress_rules" {
  description = "List of Map egress rules "
  type        = list(any)
  default     = []
}
variable "vpc_id" {
  description = "VPC to add the security group to."
  type        = string
}

variable "sysnr" {
  description = "SAP System Number"
  type        = string
}

variable "sap_base_cidr" {
  description = "List of CIDR's to allow to common user accessed ports"
  type        = list(any)
  default     = []
}

variable "sap_base_prefix" {
  description = "List of Prefix List to allow to common user accessed ports"
  type        = list(any)
  default     = []
}

variable "enable_sap_standard_http" {
  description = "Enable standard SAP http/s ports (80xx, and 443xx); default: true."
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
  description = "Is this security group for an ABAP SCS instance; default: false."
  type        = bool
  default     = false
}


variable "sap_router_sysnr" {
  description = "System number of the SAP router used; Default: 3299."
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
