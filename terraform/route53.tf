# Create a local domain name for services registration
# (maybe will be swapped to ECS discovery later btw)

resource "aws_route53_zone" "private_zone" {
  name = "${var.domain_name}"

  vpc {
    vpc_id = "${module.vpc.vpc_id}"
  }

  tags = "${local.tags}"
}
