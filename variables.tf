variable "public_subnets_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "name" {
  default = "fiap"
}

variable "region" {
  default = "us-east-1"
}

variable "cloudwatch_logs_retention" {
  default = 1
}

variable "sufix" {
  default = "fiap-project-hackaton"
}

variable "domain_name" {
  default = "soat2-gp-14-hackaton"
}
variable "docdb_username" {
  default = "fiapapi"
}

variable "docdb_password" {}


variable "environment_variables" {
  description = "Map with environment variables for the function"

  default = {
    myenvvar = "test"
  }
}

variable "ecr_repository_code" {
  default = "495428969620" //FIXME: change to new ecr?
}
  
