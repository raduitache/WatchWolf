module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = "${var.tags["Project"]}-${var.tags["Environment"]}-${var.tags["Creator"]}-${local.app_role}"
  cidr = var.cidr_range

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  database_subnets = var.database_subnets
  create_database_subnet_group = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames   = true

  tags = merge(
    var.tags,
    {
      ApplicationRole                             = "${local.app_role}"
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
  )

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}
