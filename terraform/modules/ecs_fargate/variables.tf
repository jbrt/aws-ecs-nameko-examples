# Main variables
variable "project_name" {
  description = "Name of this project"
}

# ECR Repository

variable "repository_name" {
  description = "Name of the ECR repository"
}

# VPC 

variable "vpc_id" {
  description = "VPC ID"
}


variable "private_subnets_id" {
  description = "List of Private Subnets"
  type = "list"
}


# Tags

variable "tags" {
  description = "Tags to be applied on network resources"
  type = "map"
}