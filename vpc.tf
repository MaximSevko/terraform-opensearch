
provider "aws" {
  region = var.AWS_Region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = ["${var.AWS_Region}a", "${var.AWS_Region}b", "${var.AWS_Region}c"]
  intra_subnets  = var.vpc_intra_subnets 
  public_subnets  = var.vpc_public_subnets

  enable_ipv6 = "true"

  enable_nat_gateway = var.vpc_enable_nat_gateway
  intra_subnet_ipv6_prefixes = [11,22,33]
  public_subnet_ipv6_prefixes = [1,2,3]

  public_subnet_assign_ipv6_address_on_creation = "true"


  tags = var.vpc_tags

}
