
variable "ami_name_filter" {
  description = "list of name to filter on"
  type    = list(string)
}

variable "name_prefix" {
  description = "Name to associate with the launch template"
  type = string
  default = "ePASSWebserver"
}

variable "instance_type" {
  description = "EC2 instance type"
  type = string
  default     = "t3.micro"
}

// variable "iam_instance_profile" {
//   description = "Name of IAM instance profile associated with launched instances"
//   default     = null
// }

variable "security_groups" {
  description = "List of security group names to attach"
  type = list(string)
  default     = ["ePassApp", "NCFastApp"]
}

variable "vpc_name" {
  description = "Name of VPC to create resources in"
  type        = string
}

variable "subnet_tier" {
  description = "Subnet tier to create resources in"
  type        = string
}

variable "ncfast_required_tags" {
  description = "Required tags for every resource"
  type        = map(string)
  default = {
    application-name = "NC FAST PoC Phase 1"
    business-owner   = "NC FAST"
    division         = "DSS;DCDEE"
    cost-center      = "BRM??"
    compliance       = "no hippa;pii"
    environment      = "NC FAST Proof of Concept"
    operation-owner  = "NC FAST O&M"
  }
}
