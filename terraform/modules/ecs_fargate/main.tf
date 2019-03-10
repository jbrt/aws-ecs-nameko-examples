# Create an ECS cluster
# https://registry.terraform.io/modules/tmknom/ecs-fargate/aws/1.4.0

# CloudWatch
resource "aws_cloudwatch_log_group" "logs" {
  name = "aws/ecs/${var.project_name}"
  tags = "${var.tags}"
}

# Creation of an ECR repository
resource "aws_ecr_repository" "repo" {
  name = "${var.repository_name}"
}

# Creation of the Cluster ECS
resource "aws_ecs_cluster" "cluster" {
  name = "${var.environment}-cluster"
}