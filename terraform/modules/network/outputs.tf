# Defines resources accessibles from the outside

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "private_subnets" {
  value = "${module.vpc.private_subnets}"
}

output "service_discovery" {
  value = "${aws_service_discovery_private_dns_namespace.private_zone.id}"
}

output "elasticache_subnets" {
  value = "${module.vpc.elasticache_subnets}"
}

output "database_subnets" {
  value = "${module.vpc.database_subnets}"
}