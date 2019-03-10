# Input variables for this project

variable "access_key" {}
variable "secret_key" {}

# Region and VPC variables

variable "region" {
  description = "Region where all AWS objects will be created"
  default     = "eu-west-1"
}

variable "availability_zones" {
  description = "Which AZs will be used"
  type        = "list"
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "project_name" {
  default = "nameko-examples"
}

# CloudWatch variables

variable "log_retention" {
  description = "Number of days for log retention"
  default     = 7
}

# Route53 variables

variable "domain_name" {
  description = "The DNS local domain for service registration"
  default     = "nameko.local"
}

# Tags

locals {
  tags = {
    Terraform   = "true"
    Environment = "dev"
    Project     = "Nameko-Examples-on-ECS"
  }
}
