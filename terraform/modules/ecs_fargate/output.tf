
output "ecs_cluster" {
  value = "${aws_ecs_cluster.cluster.id}"
}

output "ecs_role" {
  value = "${aws_iam_role.ecs_role.arn}"
}

output "log_group" {
  value = "${aws_cloudwatch_log_group.logs.name}"
}
