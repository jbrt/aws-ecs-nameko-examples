# We'll spawn here the needed databases

# Redis (needed for Nameko Product)

resource "aws_security_group" "redis_sg" {
  vpc_id = "${module.vpc.vpc_id}"
  name   = "RedisSGForNamekoExamples"
  tags   = "${local.tags}"
}

resource "random_string" "auth_token" {
  length  = 64
  special = false
}

module "redis" {
  source             = "cloudposse/elasticache-redis/aws"
  version            = "0.9.0"
  namespace          = "general"
  name               = "redis"
  stage              = "dev"
  security_groups    = ["${aws_security_group.redis_sg.id}"]
  auth_token         = "${random_string.auth_token.result}"
  vpc_id             = "${module.vpc.vpc_id}"
  subnets            = "${module.vpc.elasticache_subnets}"
  maintenance_window = "wed:03:00-wed:04:00"
  cluster_size       = "1"
  instance_type      = "cache.t2.micro"
  engine_version     = "4.0.10"
  apply_immediately  = "true"

  availability_zones = "${var.availability_zones}"
  automatic_failover = "false"
}

resource "aws_security_group_rule" "redis_allow_products_service" {
  type                     = "ingress"
  to_port                  = 6379
  protocol                 = "-1"
  source_security_group_id = "${module.services.redis_sg}"
  from_port                = 6379
  security_group_id        = "${aws_security_group.redis_sg.id}"
}
