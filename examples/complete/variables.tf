variable "region" {
  description = "AWS region"
}

variable "iam_source_json_url" {
  type        = string
  description = "IAM source JSON policy to download and use as `source_json` argument. These can be used as a base to append using `var.iam_policy_statements`. This is useful when using a 3rd party service that provides their own policy. This can be used with or instead of the `var.iam_policy_statements`."
  default     = null
}

variable "iam_policy_statements" {
  type        = list(any)
  description = "List of IAM policy statements to use in the policy. This can be used with or instead of the `var.iam_source_json_url`."
  default     = []
}
