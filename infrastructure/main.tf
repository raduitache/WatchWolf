module "vpc" {
  source = "./vpc"

  cidr_range         = local.env["vpc"]["cidr_range"]
  availability_zones = local.env["vpc"]["availability_zones"]
  private_subnets    = local.env["vpc"]["private_subnets"]
  public_subnets     = local.env["vpc"]["public_subnets"]
  # database_subnets = local.env["vpc"]["database_subnets"]
  tags         = local.env["tags"]
  cluster_name = "${local.env["tags"]["Project"]}-${local.env["tags"]["Project"]}-${local.env["tags"]["Project"]}-eks"
}

module "eks" {
  source = "./eks"

  public_subnets = local.env["public_subnets"]
  vpc_id         = module.vpc.vpc_id
  cidr_range     = local.env["vpc"]["cidr_range"]
  tags           = local.env["tags"]
}

module "kinesis-firehose" {
  source = "./firehose"

  tags = local.env["tags"]
}

module "ecr" {
  source = "./ecr"

  tags = local.env["tags"]
}

module "rds" {
  source = "./rds"

  vpc_id           = module.vpc.vpc_id
  cidr_range       = local.env["vpc"]["cidr_range"]
  private_subnets  = local.env["vpc"]["private_subnets"]
  tags             = local.env["tags"]
}
