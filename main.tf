resource "time_sleep" "hold_5_sec" {
  create_duration  = "10s"
  destroy_duration = "10s"
}

locals {
  common_tags = {
    "environment" = var.environment_tag
  }
}

locals {
  it_map = var.input_transformer[*]
}

locals {
  condition_map = var.event_bus_permission_condition[*]
}

locals {
  rc_map = var.run_command_targets[*]
}

locals {
  ecs_target_map = var.ecs_target[*]
}

locals {
  kt_map = var.kinesis_target[*]
}

locals {
  st_map = var.sqs_target[*]
}

locals {
  bt_map = var.batch_target[*]
}

locals {
  nc_map = var.network_configuration[*]
}

resource "aws_cloudwatch_event_bus" "event_bus" {
  count      = var.create_custom_event_bus ? 1 : 0
  depends_on = [time_sleep.hold_5_sec]
  name       = var.custom_event_bus_name
  tags       = merge(var.tags, local.common_tags)
}

resource "aws_cloudwatch_event_permission" "event_bus_permission" {
  count      = var.set_event_bus_permission ? 1 : 0
  depends_on = [time_sleep.hold_5_sec]

  principal    = var.event_bus_principal
  statement_id = var.event_bus_statement_id

  event_bus_name = var.create_custom_event_bus ? aws_cloudwatch_event_bus.event_bus[count.index].name : var.event_bus_name

  dynamic "condition" {
    for_each = local.condition_map
    content {
      key   = condition.value["key"]
      type  = condition.value["type"]
      value = condition.value["value"]
    }
  }
}

resource "aws_cloudwatch_event_rule" "event_rule" {
  count               = var.create_event_rule ? 1 : 0
  name                = var.event_rule_name
  event_bus_name      = var.create_custom_event_bus ? aws_cloudwatch_event_bus.event_bus[count.index].name : var.event_bus_name
  event_pattern       = jsonencode(var.event_pattern)
  schedule_expression = var.schedule_expression
  tags                = merge(var.tags, local.common_tags)
}

resource "aws_cloudwatch_event_target" "event_rule_target" {
  count          = var.set_event_rule_target ? 1 : 0
  rule           = var.create_event_rule ? aws_cloudwatch_event_rule.event_rule[count.index].name : var.target_event_rule_name
  arn            = var.target_arn
  event_bus_name = var.create_event_rule ? aws_cloudwatch_event_rule.event_rule[count.index].event_bus_name : var.target_event_bus_name
  target_id      = var.target_id != "" ? var.target_id : ""
  input          = var.input != "" ? var.input : ""
  role_arn       = var.role_arn != "" ? var.role_arn : ""

  dynamic "run_command_targets" {
    for_each = local.rc_map
    content {
      key    = run_command_targets.value["key"]
      values = [run_command_targets.value["values"]]
    }
  }

  dynamic "ecs_target" {
    for_each = local.ecs_target_map
    content {
      task_count          = ecs_target.value["task_count"]
      task_definition_arn = ecs_target.value["task_definition_arn"]
    }
  }

  dynamic "input_transformer" {
    for_each = local.it_map
    content {
      input_paths    = input_transformer.value["input_paths"]
      input_template = input_transformer.value["input_template"]
    }
  }

  dynamic "kinesis_target" {
    for_each = local.kt_map
    content {
      partition_key_path = kinesis_target.value["partition_key_path"]
    }
  }

  dynamic "sqs_target" {
    for_each = local.st_map
    content {
      message_group_id = sqs_target.value["message_group_id"]
    }
  }

  dynamic "batch_target" {
    for_each = local.bt_map
    content {
      job_definition = batch_target.value["job_definition"]
      job_name       = batch_target.value["job_name"]
    }
  }

}

resource "aws_lambda_permission" "for_events" {
  count         = var.set_lambda_permisson ? 1 : 0
  depends_on    = [aws_cloudwatch_event_target.event_rule_target]
  action        = var.event_action
  function_name = var.lambda_function_name
  principal     = var.lambda_principal
  source_arn    = aws_cloudwatch_event_rule.event_rule[count.index].arn
}
