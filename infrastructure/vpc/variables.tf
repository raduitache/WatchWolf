variable "tags" {
  type        = map(string)
  description = "Resource tags"
}

variable "public_subnets" {
  type = list(string)
  description = "The list of CIDR ranges for public subnets"
}

variable "private_subnets" {
  type = list(string)
  description = "The list of CIDR ranges for private subnets"
}

variable "availability_zones" {
  type = list(string)
  description = "The list of availability zones where to deploy subnets"
}
