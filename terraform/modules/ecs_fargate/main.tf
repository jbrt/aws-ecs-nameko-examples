# Create an ECS cluster

# CloudWatch
resource "aws_cloudwatch_log_group" "logs" {
  name = "/ecs/${var.project_name}"
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

# IAM

data "aws_iam_policy" "task_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "trust_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_role" {
  name               = "NamekoECSTaskExecution"
  assume_role_policy = "${data.aws_iam_policy_document.trust_policy.json}"
}

resource "aws_iam_role_policy_attachment" "attach-ecs" {
  role      = "${aws_iam_role.ecs_role.name}"
  policy_arn = "${data.aws_iam_policy.task_role_policy.arn}"
}
