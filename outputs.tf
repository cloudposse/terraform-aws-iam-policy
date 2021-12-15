output "json" {
  description = "JSON body of the IAM policy document"
  value       = try(data.aws_iam_policy_document.this[0].json, null)
}

output "policy_arn" {
  description = "ARN of created IAM policy"
  value       = join("", resource.aws_iam_policy.policy.*.arn)
}