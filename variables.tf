// variable "alb_arn" {
//   type = string
//   default = "arn:aws:elasticloadbalancing:us-east-1:533519224220:loadbalancer/app/dhhs-ncfast-poc-001-alb/064648b1ffa3eaf0"
// }

// variable "alb_name" {
//   type = string
//   # default = "internal-dhhs-ncfast-poc-001-alb-624976414.us-east-1.elb.amazonaws.com"
//   default = "dhhs-ncfast-poc-001-alb"
// }

// variable "alb_tg_name" {
//   type = string
// }

variable "key_name" {
  description = "key pair for was host"
  type = string
  default ="wasKeyPair"
}

variable "name_prefix" {
  description = "Name to associate with the launch template"
  type = string
  default = "ePASSWebserver"
}

variable "image_id" {
  description = "AMI image identifier"
  type = string
  default = "ami-00e6991c2d371feab"
}

variable "instance_type" {
  description = "EC2 instance type"
  type = string
  default     = "t3.micro"
}

variable "iam_instance_profile" {
  description = "Name of IAM instance profile associated with launched instances"
  default     = null
}

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


// Cloud-init variables..

variable "packages" {
  description = "A list of packages to install with cloud-init"
  type = list(string)
  default     = ["xclock"]
}

variable "timezone" {
  description = "Default timezone for EC2 instances"
  type = string
  default     = "US/Eastern"
}

variable "server" {
  description = "Type of server epass, ncfast etc"
  type = string
}

variable "ntp_servers" {
  description = "A list of NTP servers used for time synchronization"
  type = list(string)
  default     = []
}

variable "users" {
  description = "A list of regular user config"
  type        = list(tuple([string, string, string]))
  default     = []
}

variable "sudo_users" {
  description = "A list of sudo user configs"
  type        = list(tuple([string, string, string]))
  default     = []
}

variable "write_files" {
  description = "A list of files to configure via cloud-init (path, content)"
  type        = list(tuple([string, string]))
  default     = []
}

variable "mounts" {
  description = "A list of filesystem mounts configured via cloud-init"
  type        = list(tuple([string, string, string, string, number, number]))
  default     = []
}

variable "swap_maxsize" {
  description = "Maximum size (bytes) of swapfile (zero to disable swap)"
  type        = number
  default     = 0
}

variable "runcmd" {
  description = "A list of commands to run on first boot"
  type        = list(string)
  default     = []
}

