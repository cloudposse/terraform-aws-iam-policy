region = "us-east-2"

namespace = "eg"

environment = "ue2"

stage = "test"

name = "example"

iam_source_json_url = "https://raw.githubusercontent.com/awsdocs/amazon-lookoutmetrics-developer-guide/main/sample-policies/datasource-s3.json"

iam_policy_statements = [
  {
    sid        = "ListMyBucket"
    effect     = "Allow"
    actions    = ["s3:ListBucket"]
    resources  = ["arn:aws:s3:::test"]
    conditions = []
  },
  {
    sid        = "WriteMyBucket"
    effect     = "Allow"
    actions    = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
    resources  = ["arn:aws:s3:::test/*"]
    conditions = []
  },
]
