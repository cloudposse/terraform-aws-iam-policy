locals {
  enabled = module.this.enabled

  iam_source_json_url_body = var.iam_source_json_url != null || var.iam_source_json_url == "" ? data.http.iam_source_json_url[0].response_body : ""

  iam_override_policy_documents = var.iam_override_policy_documents == null || var.iam_override_policy_documents == [] ? [] : var.iam_override_policy_documents
  iam_source_policy_documents   = var.iam_source_policy_documents == null || var.iam_source_policy_documents == [] ? [] : var.iam_source_policy_documents

  source_policy_documents = compact(concat([local.iam_source_json_url_body], local.iam_source_policy_documents))
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

  policy_id = var.iam_policy_id
  version   = var.iam_policy_version

  override_policy_documents = local.iam_override_policy_documents != [] ? local.iam_override_policy_documents : null
  source_policy_documents   = local.source_policy_documents != [] ? local.source_policy_documents : null

  dynamic "statement" {
    for_each = var.iam_policy_statements

    content {
      sid    = coalesce(statement.value.sid, statement.key)
      effect = statement.value.effect

      actions     = statement.value.actions
      not_actions = statement.value.not_actions

      resources     = statement.value.resources
      not_resources = statement.value.not_resources

      dynamic "principals" {
        for_each = coalesce(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = coalesce(statement.value.not_principals, [])

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = coalesce(statement.value.conditions, [])

        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_policy" "default" {
  count = local.enabled && var.iam_policy_enabled ? 1 : 0

  name        = module.this.id
  description = var.description
  policy      = join("", data.aws_iam_policy_document.this.*.json)
  tags        = module.this.tags
}
