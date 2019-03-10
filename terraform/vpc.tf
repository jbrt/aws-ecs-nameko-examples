# Create the network for this project
# - Public/Private Subnets with NAT Gateway
# - DB Subnet
# - Elasticache Subnet

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.59.0"

  name                = "vpc-${var.project_name}"
  cidr                = "172.16.0.0/16"
  azs                 = "${var.availability_zones}"
  public_subnets      = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  private_subnets     = ["172.16.10.0/24", "172.16.20.0/24", "172.16.30.0/24"]
  database_subnets    = ["172.16.50.0/24", "172.16.60.0/24", "172.16.70.0/24"]
  elasticache_subnets = ["172.16.80.0/24", "172.16.90.0/24", "172.16.100.0/24"]

  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags                = "${local.tags}"
}
