region = "us-east-2"

namespace = "eg"

environment = "ue2"

stage = "test"

name = "example"

iam_source_json_url = "https://raw.githubusercontent.com/awsdocs/amazon-lookoutmetrics-developer-guide/main/sample-policies/datasource-s3.json"

# source: https://raw.githubusercontent.com/awsdocs/amazon-lookoutmetrics-developer-guide/main/sample-policies/datasource-s3.json
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "s3:ListBucket",
#                 "s3:GetBucketAcl"
#             ],
#             "Resource": [
#                 "arn:aws:s3:::${BucketName}"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "s3:GetObject",
#                 "s3:GetBucketAcl"
#             ],
#             "Resource": [
#                 "arn:aws:s3:::${BucketName}/*"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "kms:Decrypt",
#                 "kms:GenerateDataKey"
#             ],
#             "Resource": [
#                 "arn:aws:kms:::key/*"
#             ],
#             "Condition": {
#                 "ForAllValues:StringLike": {
#                     "kms:ViaService": "s3.${Region}.amazonaws.com",
#                     "kms:EncryptionContext:aws:s3:arn": [
#                         "arn:aws:s3:::${BucketName}"
#                     ]
#                 }
#             }
#         }
#     ]
# }

iam_policy_statements = {
  ListMyBucket = {
    # sid        = "ListMyBucket"
    effect     = "Allow"
    actions    = ["s3:ListBucket"]
    resources  = ["arn:aws:s3:::test"]
    conditions = []
  }
  WriteMyBucket = {
    # sid        = "WriteMyBucket"
    effect     = "Allow"
    actions    = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
    resources  = ["arn:aws:s3:::test/*"]
    conditions = []
  }
}
