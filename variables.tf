variable "iam_policy" {
  type = list(object({
    policy_id = optional(string, null)
    version   = optional(string, null)
    statements = list(object({
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
      })), [])
      principals = optional(list(object({
        type        = string
        identifiers = list(string)
      })), [])
      not_principals = optional(list(object({
        type        = string
        identifiers = list(string)
      })), [])
    }))
  }))
  description = <<-EOT
    IAM policy as list of Terraform objects, compatible with Terraform `aws_iam_policy_document` data source
    except that `source_policy_documents` and `override_policy_documents` are not included.
    Use inputs `iam_source_policy_documents` and `iam_override_policy_documents` for that.
    EOT
  default     = []
  nullable    = false
}

variable "description" {
  type        = string
  description = "Description of created IAM policy"
  default     = null
}

variable "iam_policy_enabled" {
  type        = bool
  description = "If set to `true` will create the IAM policy in AWS, otherwise will only output policy as JSON."
  default     = false
}

variable "iam_source_json_url" {
  type        = string
  description = <<-EOT
    URL of the IAM policy (in JSON format) to download and use as `source_json` argument.
    This is useful when using a 3rd party service that provides their own policy.
    Statements in this policy will be overridden by statements with the same SID in `iam_override_policy_documents`.
    EOT
  default     = null
}

variable "role_names" {
  type        = list(string)
  description = <<-EOT
    Role names to attach the policy to
  default     = null
}

variable "managed_policy_enabled" {
  type        = bool
  description = <<-EOT
    Whether to create an IAM managed policy or inline policy. If false, provide role_names is required to attach the policy.
  default     = true
}

variable "iam_source_policy_documents" {
  type        = list(string)
  description = <<-EOT
    List of IAM policy documents (as JSON strings) that are merged together into the exported document.
    Statements defined in `iam_source_policy_documents` must have unique SIDs and be distinct from SIDs
    in `iam_policy` and deprecated `iam_policy_statements`.
    Statements in these documents will be overridden by statements with the same SID in `iam_override_policy_documents`.
    EOT
  default     = null
}

variable "iam_override_policy_documents" {
  type        = list(string)
  description = <<-EOT
    List of IAM policy documents (as JSON strings) that are merged together into the exported document with higher precedence.
    In merging, statements with non-blank SIDs will override statements with the same SID
    from earlier documents in the list and from other "source" documents.
    EOT
  default     = null
}
