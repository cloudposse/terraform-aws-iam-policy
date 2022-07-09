output "json" {
  description = "JSON body of the IAM policy document"
  value       = join("", data.aws_iam_policy_document.this[*].json)
}

output "policy_arn" {
  description = "ARN of created IAM policy"
  value       = join("", aws_iam_policy.default[*].arn)
}