# Main variables
variable "project_name" {
  description = "Name of this project"
}

# ECR Repository

variable "repository_name" {
  description = "Name of the ECR repository"
}

# Tags

variable "tags" {
  description = "Tags to be applied on network resources"
  type = "map"
}