data "aws_caller_identity" "current" {}


resource "aws_opensearch_domain" "domain" {
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
    subnet_ids = []
    vpc_security_group_id = []
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

  depends_on = [aws_iam_role.role]
}
