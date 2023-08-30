output "json" {
  description = "JSON body of the IAM policy document"
  value       = module.iam_policy.json
}

output "json_two" {
  description = "JSON body of the IAM policy document created from `iam_policy_two` input"
  value       = module.iam_policy_two.json
}

output "json_three" {
  description = "JSON body of the IAM policy document created from `iam_policy_two` output"
  value       = module.iam_policy_two.json
}

output "deprecated_json_map" {
  description = "JSON body of the IAM policy document created from `iam_policy_statements_map` input"
  value       = module.iam_policy_statements_map.json
}

output "deprecated_json_list" {
  description = "JSON body of the IAM policy document created from `iam_policy_statements_list` input"
  value       = module.iam_policy_statements_list.json
}

output "url_policy_json" {
  description = "JSON rendering of the policy fetched via URL"
  value       = module.iam_url_policy.json
}
