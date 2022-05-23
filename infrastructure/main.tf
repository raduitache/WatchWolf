module "vpc" {
  source = "./vpc"

  availability_zones = local.env["vpc"]["availability_zones"]
  private_subnets = local.env["vpc"]["private_subnets"]
  public_subnets  = local.env["vpc"]["public_subnets"]
  tags            = local.env["tags"]
}
