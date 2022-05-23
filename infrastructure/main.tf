module "vpc" {
  source = "./vpc"

  cidr_range         = local.env["vpc"]["cidr_range"]
  availability_zones = local.env["vpc"]["availability_zones"]
  private_subnets    = local.env["vpc"]["private_subnets"]
  public_subnets     = local.env["vpc"]["public_subnets"]
  tags               = local.env["tags"]
}

module "eks" {
  source = "./eks"

  private_subnets = local.env["private_subnets"]
  vpc_id          = module.vpc.vpc_id
  cidr_range      = local.env["vpc"]["cidr_range"]
  tags            = local.env["tags"]
}

module "kinesis-firehose" {
  source = "./firehose"

  tags = local.env["tags"]
}
