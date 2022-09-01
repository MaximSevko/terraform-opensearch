module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = var.securitygroup_name
  description = "Security group for EC2 instance"
  vpc_id      = module.vpc.vpc_id

  ingress_ipv6_cidr_blocks = ["::/0"]

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp", "all-icmp", "ssh-tcp"]
  egress_rules        = ["all-all"]

  tags = var.securitygroup_tags
}
