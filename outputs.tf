output "json" {
  description = "JSON body of the IAM policy document"
  value       = try(data.aws_iam_policy_document.this[0].json, null)
}
