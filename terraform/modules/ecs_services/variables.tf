# Main variables
variable "region" {
  description = "Region where all AWS objects will be created"
}

variable "project_name" {
  description = "Name of this project"
}

variable "ecs_cluster" {
  description = "ID of the ECS cluster"
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
  type        = "list"
}

variable "ecs_role" {
  description = "IAM role for executing the tasks"
}

variable "log_group" {
  description = "CloudWatch Logs where send all logs"
}

variable "ecs_discovery_arn" {
  description = "ARN of the discovery service"
}

# Tags

variable "tags" {
  description = "Tags to be applied on network resources"
  type        = "map"
}
