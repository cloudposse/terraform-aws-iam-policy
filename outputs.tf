output "json" {
  description = "JSON body of the iam policy document"
  value       = try(data.aws_iam_policy_document.this[0].json, null)
}
