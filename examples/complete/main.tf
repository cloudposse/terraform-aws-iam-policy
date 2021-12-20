provider "aws" {
  region = var.region
}

module "iam_policy" {
  source = "../../"

  iam_source_json_url = var.iam_source_json_url

  iam_policy_statements = var.iam_policy_statements

  context = module.this.context
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "example" {
  name               = "hello_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  inline_policy {
    name = "test_policy"

    policy = module.iam_policy.json
  }
}
