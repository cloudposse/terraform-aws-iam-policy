region = "us-east-2"

namespace = "eg"

environment = "ue2"

stage = "test"

name = "example"

# See test/src/iam_policy_via_url.go
iam_source_json_url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.6.0/docs/install/iam_policy.json"

iam_policy = [{
  statements = [
    {
      sid     = "ListMyBucket"
      effect  = "Allow"
      actions = ["s3:ListBucket"]
      resources = [
        "arn:aws:s3:::s3_bucket_name/home/&{aws:username}",
        "arn:aws:s3:::s3_bucket_name/home/&{aws:username}/*",
      ]
      # We include an empty `principals` attribute to make this object different than the following object,
      # which makes `statements` a tuple instead of a list.
      principals = []
      conditions = [
        {
          test     = "StringLike"
          variable = "cloudwatch:namespace"
          values   = ["x-*"]
        },
      ]
    },
    {
      sid       = "WriteMyBucket"
      effect    = "Allow"
      actions   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
      resources = ["arn:aws:s3:::test/*"]
      conditions = [
        {
          test     = "StringLike"
          variable = "cloudwatch:namespace"
          values   = ["x-*"]
        },
      ]
    }
  ]
}]

iam_policy_two = [{
  statements = [
    {
      sid        = "ListMyBucket"
      effect     = "Allow"
      actions    = ["s3:ListBucket"]
      principals = []
      resources = [
        "arn:aws:s3:::s3_bucket_name/home/&{aws:username}",
        "arn:aws:s3:::s3_bucket_name/home/&{aws:username}/*",
      ]
      conditions = [
        {
          test     = "StringLike"
          variable = "cloudwatch:namespace"
          values   = ["x-*"]
        },
      ]
  }] },
  { statements = [
    {
      sid       = "WriteMyBucket"
      effect    = "Allow"
      actions   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
      resources = ["arn:aws:s3:::test/*"]
      conditions = [
        {
          test     = "StringLike"
          variable = "cloudwatch:namespace"
          values   = ["x-*"]
        },
      ]
    }
  ] }
]


iam_policy_statements_map = {
  ListMyBucket = {
    effect     = "Allow"
    actions    = ["s3:ListBucket"]
    principals = []
    resources = [
      "arn:aws:s3:::s3_bucket_name/home/&{aws:username}",
      "arn:aws:s3:::s3_bucket_name/home/&{aws:username}/*",
    ]
    conditions = [
      {
        test     = "StringLike"
        variable = "cloudwatch:namespace"
        values   = ["x-*"]
      },
    ]
  }
  WriteMyBucket = {
    effect    = "Allow"
    actions   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::test/*"]
    conditions = [
      {
        test     = "StringLike"
        variable = "cloudwatch:namespace"
        values   = ["x-*"]
      },
    ]
  }
}

iam_policy_statements_list = [
  {
    sid        = "ListMyBucket"
    effect     = "Allow"
    actions    = ["s3:ListBucket"]
    principals = []
    resources = [
      "arn:aws:s3:::s3_bucket_name/home/&{aws:username}",
      "arn:aws:s3:::s3_bucket_name/home/&{aws:username}/*",
    ]
    conditions = [
      {
        test     = "StringLike"
        variable = "cloudwatch:namespace"
        values   = ["x-*"]
      },
    ]
  },
  {
    sid       = "WriteMyBucket"
    effect    = "Allow"
    actions   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::test/*"]
    conditions = [
      {
        test     = "StringLike"
        variable = "cloudwatch:namespace"
        values   = ["x-*"]
      },
    ]
  }
]
