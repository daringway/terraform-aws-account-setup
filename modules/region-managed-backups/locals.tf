data aws_caller_identity current {}

data aws_region current {}

locals {
  tags           = var.tags
  backup_iam_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/backup"
}