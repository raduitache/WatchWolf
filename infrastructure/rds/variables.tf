variable "private_subnets" {
  type        = list(string)
  description = "The list of private subnets to use for database, because needed"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the cluster will reside"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}

variable "cidr_range" {
  type        = string
  description = "The CIDR range of the VPC"
}