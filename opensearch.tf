data "aws_caller_identity" "current" {}

resource "aws_iam_service_linked_role" "example" {
  aws_service_name = "opensearchservice.amazonaws.com"
}

resource "aws_opensearch_domain" "example" {
  domain_name    = var.domain_name
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
    subnet_id = element(module.vpc.public_subnets, 0)
    vpc_security_group_id = module.security_group.security_group_id
  }

  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:${var.AWS_Region}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}/*"
        }
    ]
}
CONFIG

  tags = var.domain_tags

  depends_on = [aws_iam_service_linked_role.example]
}
