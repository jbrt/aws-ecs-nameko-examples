output "redis_sg" {
  value = "${aws_security_group.products_sg.id}"
}

output "orders_sg" {
  value = "${aws_security_group.orders_sg.id}"
}