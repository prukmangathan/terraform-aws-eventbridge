variable "create_custom_event_bus" {
  type    = bool
  default = false
}

variable "set_event_bus_permission" {
  type    = bool
  default = false
}

variable "environment_tag" {
  type    = string
  default = "dev"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

variable "event_bus_permission_condition" {
  type    = map(string)
  default = null
}

variable "event_bus_principal" {
  type    = string
  default = "*"
}

variable "event_bus_statement_id" {
  type    = string
  default = "AllAccounts"
}

variable "custom_event_bus_name" {
  type    = string
  default = "default"
}

variable "event_bus_name" {
  type    = string
  default = "default"
}

variable "event_rule_name" {
  type    = string
  default = null
}

variable "schedule_expression" {
  default = null
}

variable "event_pattern" {
  default = null
}

variable "run_command_targets" {
  type    = map(string)
  default = null
}

variable "input_transformer" {
  default = null
}

variable "kinesis_target" {
  default = null
}

variable "sqs_target" {
  default = null
}

variable "batch_target" {
  default = null
}

variable "network_configuration" {
  default = null
}

variable "ecs_target" {
  type    = map(string)
  default = null
}

variable "target_arn" {
  type    = string
  default = null
}

variable "target_id" {
  type    = string
  default = null
}

variable "input" {
  default = null
}

variable "role_arn" {
  type    = string
  default = null
}

variable "set_lambda_permisson" {
  type    = bool
  default = false
}

variable "event_action" {
  type    = string
  default = "lambda:InvokeFunction"
}

variable "lambda_function_name" {
  type    = string
  default = null
}

variable "lambda_principal" {
  type    = string
  default = "events.amazonaws.com"
}

variable "create_event_rule" {
  type    = bool
  default = false
}

variable "set_event_rule_target" {
  type    = bool
  default = false
}

variable "target_event_rule_name" {
  type = string
  default = null
}

variable "target_event_bus_name" {
  type = string
  default = "default"
}
