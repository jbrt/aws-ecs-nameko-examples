# We'll spawn here the needed databases

# Redis (needed for Nameko Product)
module "redis" {
  source             = "cloudposse/elasticache-redis/aws"
  version            = "0.9.0"
  namespace          = "general"
  name               = "redis"
  stage              = "dev"
  zone_id            = "${module.vpc.service_discovery}"
  security_groups    = ["${var.security_group_id}"]        # TODO: add here the product SG
  auth_token         = ""
  vpc_id             = "${module.vpc.vpc_id}"
  subnets            = "${module.vpc.elasticache_subnets}"
  maintenance_window = "wed:03:00-wed:04:00"
  cluster_size       = "1"
  instance_type      = "cache.t2.micro"
  engine_version     = "5.0.3"

  # alarm_cpu_threshold_percent  = "${var.cache_alarm_cpu_threshold_percent}"
  # alarm_memory_threshold_bytes = "${var.cache_alarm_memory_threshold_bytes}"
  apply_immediately = "true"

  availability_zones = "${var.availability_zones}"
  automatic_failover = "false"
}
