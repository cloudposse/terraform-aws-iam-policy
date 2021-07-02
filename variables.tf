variable "iam_source_json_url" {
  type        = string
  description = "IAM source json policy to download"
  default     = null
}

variable "iam_policy_statements" {
  type        = list(any)
  description = "List of IAM policy statements"
  default     = []
}
