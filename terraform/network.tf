# Create the network for this project

module "vpc" {
  source             = "./modules/network"
  region             = "${var.region}"
  availability_zones = "${var.availability_zones}"
  project_name       = "${var.project_name}"
  domain_name        = "${var.domain_name}"
  tags               = "${local.tags}"
}
