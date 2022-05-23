module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = "${var.tags["Project"]}-${var.tags["Environment"]}-${var.tags["Creator"]}-${local.app_role}"
  cidr = "10.0.0.0/16"

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  tags = merge(
    var.tags,
    {
      ApplicationRole = "${local.app_role}"
  })
}
