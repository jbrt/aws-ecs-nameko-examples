# Creation of the RabbitMQ service
# - Creating a task definition
# - Creating a Security Group
# - Creating an entry into the ECS discovery
# - Creating an ECS Service

# Create a simple task definition
data "template_file" "task_file" {
  template = "${file("${path.module}/files/task_rabbitmq.json")}"

  vars {
    region     = "${var.region}"
    image      = "rabbitmq"
    log_group  = "${var.log_group}"
    log_prefix = "rabbitmq"
  }
}

resource "aws_ecs_task_definition" "rabbitmq" {
  family                   = "rabbitmq_task"
  container_definitions    = "${data.template_file.task_file.rendered}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "${var.ecs_role}"
  task_role_arn            = "${var.ecs_role}"
}

# Security Group
resource "aws_security_group" "ecs_service" {
  vpc_id = "${var.vpc_id}"
  name   = "Nameko-rabbitmq-service"

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

# Discovery
resource "aws_service_discovery_service" "discovery_rabbitmq" {
  name = "rabbitmq"

  dns_config {
    namespace_id = "${var.ecs_discovery_id}"

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

# ECS Service
resource "aws_ecs_service" "rabbitmq-service" {
  name            = "rabbitmq"
  cluster         = "${var.ecs_cluster}"
  task_definition = "${aws_ecs_task_definition.rabbitmq.family}:${max("${aws_ecs_task_definition.rabbitmq.revision}")}"
  desired_count   = 1
  launch_type     = "FARGATE"

  # iam_role = "${aws_iam_role.ecs_role.name}"
  network_configuration {
    security_groups = ["${aws_security_group.ecs_service.id}"]
    subnets         = ["${var.private_subnets_id}"]
  }

  service_registries = {
    registry_arn   = "${aws_service_discovery_service.discovery_rabbitmq.arn}"
    container_name = "rabbitmq"
  }
}
