output "redis_sg" {
  value = "${aws_security_group.products_sg.id}"
}
