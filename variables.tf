variable "iam_source_json_url" {
  type        = string
  description = "IAM source JSON policy to download and use as `source_json` argument. This is useful when using a 3rd party service that provides their own policy. This can be used with or instead of the `var.iam_policy_statements`."
  default     = null
}

variable "iam_policy_statements" {
  type = map(object({
    sid           = optional(string, null)
    effect        = optional(string, null)
    actions       = optional(list(string), null)
    not_actions   = optional(list(string), null)
    resources     = optional(list(string), null)
    not_resources = optional(list(string), null)
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })), null)
    principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })), null)
    not_principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })), null)
  }))
  description = "Map of IAM policy statements to use in the policy. This can be used with or instead of the `var.iam_source_json_url`."
  default     = {}
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

variable "iam_policy_id" {
  type        = string
  description = "ID for the policy document."
  default     = null
}

variable "iam_policy_version" {
  type        = string
  description = "IAM policy document version."
  default     = "2012-10-17"
  validation {
    condition     = contains(["2008-10-17", "2012-10-17"], var.iam_policy_version)
    error_message = "The iam_policy_version valid values are '2008-10-17' or '2012-10-17'."
  }
}

variable "iam_source_policy_documents" {
  type        = list(string)
  description = "List of IAM policy documents that are merged together into the exported document. Statements defined in `source_policy_documents` or `source_json` must have unique sids. Statements with the same sid from documents assigned to the `override_json` and `override_policy_documents` arguments will override source statements."
  default     = null
}

variable "iam_override_policy_documents" {
  type        = list(string)
  description = "List of IAM policy documents that are merged together into the exported document. In merging, statements with non-blank sids will override statements with the same sid from earlier documents in the list. Statements with non-blank sids will also override statements with the same sid from documents provided in the `source_json` and `source_policy_documents` arguments. Non-overriding statements will be added to the exported document."
  default     = null
}
