locals {
  enabled = module.this.enabled
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

  source_json = var.iam_source_json_url != null ? data.http.iam_source_json_url[0].body : null

  dynamic "statement" {
    for_each = var.iam_policy_statements

    content {
      sid    = lookup(statement.value, "sid", null)
      effect = lookup(statement.value, "effect", null)

      actions     = lookup(statement.value, "actions", null)
      not_actions = lookup(statement.value, "not_actions", null)

      resources     = lookup(statement.value, "resources", null)
      not_resources = lookup(statement.value, "not_resources", null)

      dynamic "principals" {
        for_each = lookup(statement.value, "principals", [])

        content {
          type        = principals.value.type
          identifiers = condiprincipalstion.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = lookup(statement.value, "not_principals", [])

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = lookup(statement.value, "conditions", [])

        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}
