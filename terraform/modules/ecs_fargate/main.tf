# Create an ECS cluster
# https://registry.terraform.io/modules/tmknom/ecs-fargate/aws/1.4.0

# CloudWatch
resource "aws_cloudwatch_log_group" "logs" {
  name = "ecs/${var.project_name}"
  tags = "${var.tags}"
}

# Creation of an ECR repository
resource "aws_ecr_repository" "repo" {
  name = "${var.repository_name}"
}

# Creation of the Cluster ECS
resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-cluster"
}

# Creation of the Task Definitions

module "td_rabbitmq" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.7.0"

  container_image = "rabbitmq:3.7.12-alpine"
  container_name  = "rabbitmq"

  port_mappings = [
    {
      containerPort = 5672
      hostPort      = 5672
      protocol      = "tcp"
    },
  ]
}

resource "aws_ecs_task_definition" "rabbitmq" {
  family                   = "rabbitmq"
  container_definitions    = "${module.td_rabbitmq.json}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
}
# TODO : before creating a Fargate Task definition it's mandatory to use 
# (or use) an IAM role with CloudWatch rights