# Input variables for network resources

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

# Route53 variables

variable "domain_name" {
  description = "The DNS local domain for service registration"
}

# Tags

variable "tags" {
  description = "Tags to be applied on network resources"
  type = "map"
}
