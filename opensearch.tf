
data "aws_subnet_ids" "example" {
  vpc_id = data.aws_vpc.example.id

  tags = {
    Tier = "private"
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_security_group" "example" {
  name        = "Opensearch-${var.domain_name}"
  description = "Managed by Terraform"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      data.aws_vpc.example.cidr_block,
    ]
  }
}

resource "aws_iam_service_linked_role" "example" {
  aws_service_name = "opensearchservice.amazonaws.com"
}

resource "aws_opensearch_domain" "example" {
  domain_name    = var.domain
  engine_version = "OpenSearch_1.3"

   

  ebs_options {
    ebs_enabled = true
    volume_size = 10
    volume_type = "gp3"
  }

  cluster_config {
    instance_count = 1
    instance_type  = "t3.small.search"
    zone_awareness_enabled = false
  }

  vpc_options {
    subnet_ids = [
      data.aws_subnet_ids.example.ids[0],
    ]

    security_group_ids = [aws_security_group.example.id]
  }

  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*"
        }
    ]
}
CONFIG

  tags = {
    Domain = "TestDomain"
  }

  depends_on = [aws_iam_service_linked_role.example]
}