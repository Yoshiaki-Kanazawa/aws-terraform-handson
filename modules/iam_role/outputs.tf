output "iam_role_arn" {
  value = aws_iam_role.default.arn
  description = "This is an arn of the iam role."
}

output "iam_role_name" {
  value = aws_iam_role.default.name
  description = "This is a name of the iam role."
}