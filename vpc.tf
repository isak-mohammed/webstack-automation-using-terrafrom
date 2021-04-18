module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name            = var.VPC_NAME
  cidr            = var.VPC_CIDR
  azs             = [var.AZ_1, var.AZ_2, var.AZ_3]
  private_subnets = [var.Private_Subnet_1, var.Private_Subnet_2, var.Private_Subnet_3]
  public_subnets  = [var.Public_Subnet_1, var.Public_Subnet_2, var.Public_Subnet_3]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Owner       = "Isak"
    Terraform   = "True"
    Environment = "dev"
  }

  vpc_tags = {
    Name = var.VPC_NAME
  }

}
