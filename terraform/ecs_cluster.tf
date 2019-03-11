# Creating an ECS cluster (Fargate mode)

module "ecs" {
  source          = "./modules/ecs_fargate"
  project_name    = "${var.project_name}"
  repository_name = "${var.repository_name}"
  tags            = "${local.tags}"
}
