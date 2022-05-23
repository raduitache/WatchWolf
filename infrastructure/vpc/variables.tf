variable "tags" {
  type        = map(string)
  description = "Resource tags"
}

variable "public_subnets" {
  type        = list(string)
  description = "The list of CIDR ranges for public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "The list of CIDR ranges for private subnets"
}

variable "database_subnets" {
  type        = list(string)
  description = "The list of CIDR ranges for database subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "The list of availability zones where to deploy subnets"
}

variable "cidr_range" {
  type        = string
  description = "The CIDR range the VPC will use"
}

variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster."
}
