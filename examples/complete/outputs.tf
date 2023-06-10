output "json" {
  description = "JSON body of the IAM policy document"
  value       = module.iam_policy.json
}

output "deprecated_json" {
  description = "JSON body of the IAM policy document"
  value       = module.iam_policy_statements.json
}
