# Defines resources accessibles from the outside

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "private_subnets" {
  value = "${module.vpc.private_subnets_cidr_blocks}"
}

