variable "vpc_id" {
  type = string
  description = "This is a VPC ID for subnet."
}

variable "cidr_block" {
  type = string
  description = "This is a CIDR BLOCK for subnet."
}

variable "is_public" {
  type = bool
  description = "This is a boolean variable if subnet is public."
}

variable "availability_zone" {
  type = string
  description = "This is a availability zone where the subnet will be located."
}

variable "name" {
  type = string
  description = "This is a name of the subnet."
}