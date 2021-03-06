resource aws_iam_instance_profile ec2_profile {
  name = "${local.instance_profile_name}-profile"
  role = aws_iam_role.ec2_role.name
}

data aws_iam_policy_document ec2_assume_policy_document {
  version = "2012-10-17"

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource aws_iam_role ec2_role {
  name               = "${local.instance_profile_name}-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_policy_document.json
  tags               = local.tags
}

data aws_iam_policy_document ec2_access_policy_document {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeTags"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
      "ssm:DescribePrameters"
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/global/*"
    ]
  }
}

resource aws_iam_role_policy ec2_access_policy {
  name   = "access_policy"
  role   = aws_iam_role.ec2_role.id
  policy = data.aws_iam_policy_document.ec2_access_policy_document.json
}