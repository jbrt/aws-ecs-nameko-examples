# We'll spawn here the needed databases

###################################
# Redis (needed for Nameko Product)
###################################

resource "aws_security_group" "redis_sg" {
  vpc_id = "${module.vpc.vpc_id}"
  name   = "RedisSGForNamekoExamples"
  tags   = "${local.tags}"
}

resource "random_string" "auth_token" {
  length  = 64
  special = false
}

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

resource "aws_security_group_rule" "redis_allow_products_service" {
  type                     = "ingress"
  to_port                  = 6379
  protocol                 = "-1"
  source_security_group_id = "${module.services.redis_sg}"
  from_port                = 6379
  security_group_id        = "${aws_security_group.redis_sg.id}"
}

#######################################
# PostGreSQL (needed for Nameko Orders)
#######################################

resource "aws_security_group" "postgresql_sg" {
  vpc_id = "${module.vpc.vpc_id}"
  name   = "PostGreSQLSGForNamekoExamples"
  tags   = "${local.tags}"
}

resource "aws_db_subnet_group" "postgre_subnet" {
  name       = "nameko-postgre-subnet"
  subnet_ids = ["${module.vpc.database_subnets}"]
  tags = "${local.tags}"
}

resource "aws_db_instance" "postgresql" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "9.6.6"
  instance_class       = "db.t2.micro"
  name                 = "postgresqlnameko"
  username             = "superuser"
  password             = "${random_string.auth_token.result}"
  parameter_group_name = "default.postgres9.6"
  tags = "${local.tags}"
}

resource "aws_security_group_rule" "postgre_allow_orders_service" {
  type                     = "ingress"
  to_port                  = 5432
  protocol                 = "-1"
  source_security_group_id = "${module.services.orders_sg}"
  from_port                = 5432
  security_group_id        = "${aws_security_group.postgresql_sg.id}"
}