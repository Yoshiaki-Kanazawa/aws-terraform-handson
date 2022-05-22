output "sg_id" {
  value = aws_security_group.default.id
  description = "This is a resource id of the security group."
}

output "sg_name" {
  value = aws_security_group.default.name
  description = "This is a name id of the security group."
}