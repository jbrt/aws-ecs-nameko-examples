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

/*
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
*/

resource "aws_elasticache_subnet_group" "redis_subnet" {
  name       = "nameko-redis-subnet"
  subnet_ids = ["${module.vpc.elasticache_subnets}"]
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "redis-nameko"
  engine               = "redis"
  node_type            = "cache.t2.small"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.3"
  port                 = 6379
  security_group_ids   = ["${aws_security_group.redis_sg.id}"]
  subnet_group_name    = "${aws_elasticache_subnet_group.redis_subnet.name}"
}

/*
output "nodes" {
  value = "${lookup(aws_elasticache_cluster.redis.cache_nodes[0], "address")}"
}
*/

resource "aws_security_group_rule" "redis_allow_products_service" {
  type                     = "ingress"
  to_port                  = 6379
  protocol                 = "-1"
  source_security_group_id = "${module.services.redis_sg}"
  from_port                = 6379
  security_group_id        = "${aws_security_group.redis_sg.id}"
}
