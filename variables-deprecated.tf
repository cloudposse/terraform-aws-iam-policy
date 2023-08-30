variable "iam_policy_statements" {
  type        = any
  description = <<-EOT
    Deprecated: Use `iam_policy` instead.
    List or Map of IAM policy statements to use in the policy.
    This can be used with `iam_source_policy_documents` and `iam_override_policy_documents`
    and with or instead of `iam_source_json_url`.
    EOT
  default     = []
  nullable    = false
}

variable "iam_policy_id" {
  type        = string
  description = "Deprecated: Use `iam_policy` instead: ID for the policy document when using `iam_policy_statements`."
  default     = null
}

locals {
  # var.iam_policy_statements is deprecated in favor of var.iam_policy
  # It could be a list of objects or a map of objects. If it is a map,
  # the key is used as the SID if the SID is not specified in the object.
  # If it is a list, the SID is allowed to be null.
  deprecated_statements_keys   = try(keys(var.iam_policy_statements), [null])
  deprecated_statements_values = try(values(var.iam_policy_statements), var.iam_policy_statements)
  deprecated_statements_with_sid = !local.enabled || var.iam_policy_statements == null ? [] : [
    for i, v in local.deprecated_statements_values :
    merge(v, lookup(v, "sid", null) == null ? { sid = element(local.deprecated_statements_keys, i) } : {})
  ]

  deprecated_policy = local.enabled && length(local.deprecated_statements_with_sid) > 0 ? [{
    version   = null
    policy_id = var.iam_policy_id
    statements = [for i, v in local.deprecated_statements_with_sid : {
      sid           = lookup(v, "sid", null)
      effect        = lookup(v, "effect", null)
      actions       = lookup(v, "actions", null)
      not_actions   = lookup(v, "not_actions", null)
      resources     = lookup(v, "resources", null)
      not_resources = lookup(v, "not_resources", null)

      conditions = [
        for c in lookup(v, "conditions", []) : {
          test     = c.test
          variable = c.variable
          values   = c.values
        }
      ]

      principals = [
        for p in lookup(v, "principals", []) : {
          type        = p.type
          identifiers = p.identifiers
        }
      ]

      not_principals = [
        for p in lookup(v, "not_principals", []) : {
          type        = p.type
          identifiers = p.identifiers
        }
      ]
    }]
  }] : []
}
