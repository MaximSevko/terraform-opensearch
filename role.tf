resource "aws_iam_role" "role" {
  name = var.role_name
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "sts:AssumeRole",
        "sts:TagSession",
        "sts:SetSourceIdentity"
      ]
      Principal = {
               "Service": "ec2.amazonaws.com"
      }
      Effect = "Allow"
      Sid    = ""
    }]
  })
}

resource "aws_iam_instance_profile" "test" {
  name      = var.role_name
  role = aws_iam_role.role.name
}

