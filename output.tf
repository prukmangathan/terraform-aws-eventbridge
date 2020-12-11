output "event_bus_arn" {
  value = element(concat(aws_cloudwatch_event_bus.event_bus.*.arn, [""]), 0)
}

output "event_rule_arn" {
  value = element(concat(aws_cloudwatch_event_rule.event_rule.*.arn, [""]), 0)
}

output "event_rule_name" {
  value = element(concat(aws_cloudwatch_event_rule.event_rule.*.id, [""]), 0)
}
