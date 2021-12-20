variable "iam_source_json" {
  type        = string
  description = "IAM source JSON policy to use as `source_json` argument. This can be used with or instead of the `var.iam_policy_statements`. this cannot be used with `var.iam_source_json_url`."
  default     = null
}

variable "iam_source_json_url" {
  type        = string
  description = "IAM source JSON policy to download and use as `source_json` argument. This is useful when using a 3rd party service that provides their own policy. This can be used with or instead of the `var.iam_policy_statements`."
  default     = null
}

# Note: cannot be a list(any) as terraform complains
variable "iam_policy_statements" {
  type        = any
  description = "List of IAM policy statements to use in the policy. This can be used with or instead of the `var.iam_source_json_url`."
  default     = []
}

variable "description" {
  type        = string
  description = "Description of IAM policy"
  default     = null
}

variable "iam_policy_enabled" {
  type        = bool
  description = "If set to true will create IAM policy in AWS"
  default     = false
}