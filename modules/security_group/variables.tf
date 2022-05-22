variable "name" {
  type = string
  description = "This is a name of the security group."
}

variable "vpc_id" {
  type = string
  description = "This is a VPC ID for the security group."
}

variable "ingress_rules" {
  type = map(
      object(
          {
              port = number
              cidr_blocks = list(string)
              security_groups = list(string)
          }
      )
  )
  description = "This is ingress rules for the security group."
}