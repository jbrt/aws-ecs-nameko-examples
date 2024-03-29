# Creation of the Gateway service
# - Creating a task definition
# - Creating a Security Group
# - Creating an entry into the ECS discovery
# - Creating an ECS Service

# Create a simple task definition
data "template_file" "task_gateway" {
  template = "${file("${path.module}/files/task_gateway.json")}"

  vars {
    region      = "${var.region}"
    image       = "nameko/nameko-example-gateway"
    log_group   = "${var.log_group}"
    log_prefix  = "gateway"
    rabbit_host = "rabbitmq.nameko.local"
    rabbit_port = 5672
  }
}

resource "aws_ecs_task_definition" "gateway" {
  family                   = "gateway_task"
  container_definitions    = "${data.template_file.task_gateway.rendered}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "${var.ecs_role}"
  task_role_arn            = "${var.ecs_role}"
}

# Security Group
resource "aws_security_group" "gateway_sg" {
  vpc_id = "${var.vpc_id}"
  name   = "Nameko-gateway-service"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${var.tags}"
}

# Discovery
resource "aws_service_discovery_service" "discovery_gateway" {
  name = "gateway"

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
resource "aws_ecs_service" "gateway-service" {
  name            = "gateway"
  cluster         = "${var.ecs_cluster}"
  task_definition = "${aws_ecs_task_definition.gateway.family}:${max("${aws_ecs_task_definition.gateway.revision}")}"
  desired_count   = 1
  launch_type     = "FARGATE"
  depends_on      = ["aws_ecs_service.rabbitmq-service"]

  # iam_role = "${aws_iam_role.ecs_role.name}"
  network_configuration {
    security_groups = ["${aws_security_group.gateway_sg.id}"]
    subnets         = ["${var.private_subnets_id}"]
  }

  service_registries = {
    registry_arn   = "${aws_service_discovery_service.discovery_gateway.arn}"
    container_name = "gateway"
  }
}
