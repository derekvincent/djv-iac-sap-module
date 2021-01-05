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

##
## SAP Tag Variables
##

variable "fqdn" {
  description = "The fully qualified domain name to be used in the hostname tag."
  type        = string
  default     = ""
}
variable "sap_type" {
  description = "Type of SAP instance - ABAP, J2EE, HANA, WD."
  type        = string
  default     = "ABAP"
}

variable "sap_application" {
  description = "SAP Application being deployed - ie. ECC, S/4, BW, BW/4, CRM, GRC, EP, NW-ABAP."
  type        = string
}

variable "sap_application_version" {
  description = "The main SAP Application version - used in tagging."
  type        = string
}

variable "sap_netweaver_version" {
  description = "Technical version of the underlying Netweaver stack - used in tagging."
  type        = string
}

variable "sap_instance_type" {
  description = "Type of SAP instance modes deployed on the host - ASCS, DIALOG"
  type        = string
}
##
##
##
variable "vpc_id" {
  description = "The VPC ID where the system and related components will be created."
  type        = string
}

variable "security_group_egress_rules" {
  description = <<-HEREDOC
  Security group egress rules, default to allow everything.  
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
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow everythig to everywhere."
    }
  ]

}

variable "security_group_ingress_rules" {
  description = <<-HEREDOC
  Security group ingress rules, default to allow ICMP and SSH from everywhere.  
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
  default = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow ICMP from everywhere"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow Ping from everywhere"
    }
  ]
}

## Host and SAP Setup 
variable "hostname" {
  description = "Hostname for the instnace, omit the domain name as it will be applied as per the VPC."
  type        = string
}

# SAP 
variable "sap_sid" {
  description = "SAP System ID."
  type        = string
}

variable "sap_sysnr" {
  description = "SAP System Number."
  type        = string
}

## 
## EC2 Creation Values
##

variable "ec2_ami" {
  description = "AMI for the Instance being created."
  type        = string
}

variable "ec2_instance_type" {
  description = "EC2 Instance Type."
  type        = string
}

variable "key_name" {
  description = "An existing EC2 instance keypair to use."
  type        = string
}

variable "subnet_id" {
  description = "VPC Subnet ID to deploy the instance into."
  type        = string
}

variable "enable_enhanced_monitoring" {
  description = "Enable Enhanced Cloudwatch Monitoring."
  type        = bool
  default     = true
}

variable "enable_public_address" {
  description = "Enable assignment of a public address when in a public subnet."
  type        = bool
  default     = false
}

variable "ec2_private_ip" {
  description = "Sets the instances IP address. If not set then an IP from thee subnet ranging will be assigned."
  type        = string
  default     = null
}

variable "ebs_optimized" {
  description = "Enable the EBS optimization on the instance if support."
  type        = bool
  default     = false
}

variable "termination_protection" {
  description = "Instance termination protection. IMPORTANT: This currently does not protect assigned EBS disk from `terraform destroy`."
  type        = bool
  default     = true
}

variable "root_volume_type" {
  description = "Root Volume type - standard, gp2, io1 or io2."
  type        = string
  default     = "gp2"
}

variable "root_volume_size" {
  description = "Root Volume size."
  type        = string
  default     = "20"
}

variable "root_volume_encrypted" {
  description = "Enable Root Volume Encryption."
  type        = bool
  default     = true
}

variable "swap_volume_type" {
  description = "Swap Volume type - standard, gp2, io1 or io2."
  type        = string
  default     = "standard"
}

variable "swap_volume_size" {
  description = "Swap Volume size."
  type        = string
}

variable "swap_volume_encrypted" {
  description = "Enable Swap Volume Encryption."
  type        = bool
  default     = true
}

variable "ebs_disk_layouts" {
  description = <<-HEREDOC
  Map of the additional ebs values to be added.
  ```
  { 
    "sdf" : {"type": "gp2", "size": 120, "encrypted": true, "description": "sap volume"},
    "sdh" : {"type": "gp2", "size": 200, "encrypted": true, "description": "db volume"},
    "sdm" : {"type": "gp2", "size": 150, "encrypted": true, "description": "backup"},
    "sdo" : {"type": "gp2", "size": 300, "encrypted": true, "description": "sltools"},   
  }
  ```                   
  HEREDOC
  type        = map(any)
}

variable "efs_access_point" {
  description = "Map of the EFS access points avaliable. Keyed on system type identifier."
  type        = map(any)
  default     = {}

}

variable "assumed_shared_roles" {
  description = "List of possible roles that the instance can assume."
  type        = list(string)
  default     = []
}

variable "additional_security_groups" {
  description = "Additional Security groups to add to the instance."
  type        = list(any)
  default     = []
}