locals {
  enabled = module.this.enabled

  iam_source_json_url_body = try(length(var.iam_source_json_url), 0) > 0 ? one(data.http.iam_source_json_url[*].response_body) : null

  iam_override_policy_documents = try(length(var.iam_override_policy_documents), 0) > 0 ? var.iam_override_policy_documents : []
  iam_source_policy_documents   = try(length(var.iam_source_policy_documents), 0) > 0 ? var.iam_source_policy_documents : []

  source_policy_documents = compact(concat([local.iam_source_json_url_body], data.aws_iam_policy_document.policy[*].json, local.iam_source_policy_documents))

  policy = concat(local.deprecated_policy, var.iam_policy)
}

data "http" "iam_source_json_url" {
  count = local.enabled && var.iam_source_json_url != null ? 1 : 0

  url = var.iam_source_json_url
  request_headers = {
    Accept = "application/json"
  }
}

data "aws_iam_policy_document" "policy" {
  count = local.enabled ? length(local.policy) : 0

  policy_id = local.policy[count.index].policy_id
  version   = local.policy[count.index].version

  dynamic "statement" {
    for_each = local.policy[count.index].statements

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
}

data "aws_iam_policy_document" "this" {
  count = local.enabled ? 1 : 0

  source_policy_documents   = local.source_policy_documents
  override_policy_documents = local.iam_override_policy_documents
}

resource "aws_iam_policy" "default" {
  count = local.enabled && var.iam_policy_enabled ? 1 : 0

  name        = module.this.id
  description = var.description
  policy      = one(data.aws_iam_policy_document.this[*].json)
  tags        = module.this.tags
}
