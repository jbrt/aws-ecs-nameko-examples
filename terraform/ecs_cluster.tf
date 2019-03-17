# Creating an ECS cluster (Fargate mode)

module "ecs" {
  source             = "./modules/ecs_fargate"
  project_name       = "${var.project_name}"
  repository_name    = "${var.repository_name}"
  vpc_id             = "${module.vpc.vpc_id}"
  private_subnets_id = ["${module.vpc.private_subnets}"]
  tags               = "${local.tags}"
}

module "services" {
  source             = "./modules/ecs_services"
  region             = "${var.region}"
  project_name       = "${var.project_name}"
  repository_name    = "${var.repository_name}"
  vpc_id             = "${module.vpc.vpc_id}"
  private_subnets_id = ["${module.vpc.private_subnets}"]
  ecs_cluster        = "${module.ecs.ecs_cluster}"
  ecs_role           = "${module.ecs.ecs_role}"
  ecs_discovery_id   = "${module.vpc.service_discovery}"
  log_group          = "${module.ecs.log_group}"
  tags               = "${local.tags}"

  redis_host         = "${lookup(aws_elasticache_cluster.redis.cache_nodes[0], "address")}"
  redis_password     = ""
}
