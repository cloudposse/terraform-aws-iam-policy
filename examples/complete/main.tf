provider "aws" {
  region = var.region
}

module "iam_policy" {
  source = "../../"

  iam_source_json_url = var.iam_source_json_url

  iam_policy         = var.iam_policy
  iam_policy_enabled = false

  context = module.this.context
}

module "iam_policy_statements" {
  source = "../../"

  iam_source_json_url = var.iam_source_json_url

  iam_policy_statements = var.iam_policy_statements
  iam_policy_enabled    = false

  context = module.this.context
}


data "aws_iam_policy_document" "assume_role" {
  count = module.this.enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "default" {
  count = module.this.enabled ? 1 : 0

  name               = module.this.id
  assume_role_policy = one(data.aws_iam_policy_document.assume_role[*].json)

  inline_policy {
    name = "test_policy"

    policy = module.iam_policy.json
  }
}
