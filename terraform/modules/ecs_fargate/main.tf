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
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_role" {
  name               = "ecs_role"
  assume_role_policy = "${data.aws_iam_policy_document.trust_policy.json}"
}

resource "aws_iam_role_policy_attachment" "attach-ecs" {
  role      = "${aws_iam_role.ecs_role.name}"
  policy_arn = "${data.aws_iam_policy.task_role_policy.arn}"
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
  cpu                      = "256"
  memory                   = "512"
  #task_role_arn            = "${aws_iam_role.ecs_role.arn}"
  execution_role_arn       = "${aws_iam_role.ecs_role.arn}"
}

resource "aws_security_group" "ecs_service" {
  vpc_id      = "${var.vpc_id}"
  name        = "${var.project_name}-ecs-service-sg"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${var.tags}"
}


resource "aws_ecs_service" "rabbitmq-service" {
  name = "rabbitmq"
  cluster = "${aws_ecs_cluster.cluster.id}"
  task_definition = "${aws_ecs_task_definition.rabbitmq.family}:${max("${aws_ecs_task_definition.rabbitmq.revision}")}"
  desired_count = 1
  # iam_role = "${aws_iam_role.ecs_role.name}"
  network_configuration {
    security_groups = ["${aws_security_group.ecs_service.id}"]
    subnets         = "${var.private_subnets_id}"
  }
}