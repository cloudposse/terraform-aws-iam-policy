locals {
  enabled = module.this.enabled

  iam_source_json_url_body = try(length(var.iam_source_json_url), 0) > 0 ? one(data.http.iam_source_json_url[*].response_body) : null

  iam_override_policy_documents = try(length(var.iam_override_policy_documents), 0) > 0 ? var.iam_override_policy_documents : []
  iam_source_policy_documents   = try(length(var.iam_source_policy_documents), 0) > 0 ? var.iam_source_policy_documents : []

  source_policy_documents = compact(concat([local.iam_source_json_url_body], local.iam_source_policy_documents))

  deprecated_statements_with_sid = var.iam_policy_statements == null ? [] : [
    for k, v in var.iam_policy_statements : merge(v, v.sid == null ? { sid = k } : {})
  ]
  deprecated_policy = {
    version    = null
    policy_id  = var.iam_policy_id
    statements = local.deprecated_statements_with_sid
  }

  policy = var.iam_policy == null ? local.deprecated_policy : var.iam_policy
}

data "http" "iam_source_json_url" {
  count = local.enabled && var.iam_source_json_url != null ? 1 : 0

  url = var.iam_source_json_url
  request_headers = {
    Accept = "application/json"
  }
}

data "aws_iam_policy_document" "this" {
  count = local.enabled ? 1 : 0

  policy_id = local.policy.policy_id
  version   = local.policy.version

  override_policy_documents = local.iam_override_policy_documents
  source_policy_documents   = local.source_policy_documents

  dynamic "statement" {
    for_each = local.policy.statements

    content {
      sid    = statement.value.sid
      effect = statement.value.effect

      actions     = statement.value.actions
      not_actions = statement.value.not_actions

      resources     = statement.value.resources
      not_resources = statement.value.not_resources

      dynamic "principals" {
        for_each = statement.value.principals

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = statement.value.not_principals

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = statement.value.conditions

        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }

  lifecycle {
    precondition {
      condition     = var.iam_policy_statements == null || var.iam_policy == null
      error_message = "Only 1 of var.iam_policy and var.iam_policy_statments may be used, preferably var.iam_policy."
    }
    precondition {
      condition     = var.iam_policy_statements != null || var.iam_policy != null
      error_message = "Exactly 1 of var.iam_policy and var.iam_policy_statments may be used, preferably var.iam_policy."
    }
  }
}

resource "aws_iam_policy" "default" {
  count = local.enabled && var.iam_policy_enabled ? 1 : 0

  name        = module.this.id
  description = var.description
  policy      = one(data.aws_iam_policy_document.this[*].json)
  tags        = module.this.tags
}
