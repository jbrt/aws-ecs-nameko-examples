# Creating an ECS cluster (Fargate mode)

module "ecs" {
  source          = "./modules/ecs_fargate"
  project_name    = "${var.project_name}"
  repository_name = "${var.repository_name}"
  vpc_id          = "${module.vpc.vpc_id}"
  private_subnets_id = ["${module.vpc.private_subnets}"]
  tags            = "${local.tags}"
}
