create_custom_event_bus = true
custom_event_bus_name = "terra-test-eventbus"
tags = {
  type = "inventory"
}
environment_tag = "dev"

set_event_bus_permission = true
event_bus_principal = "*"
event_bus_statement_id = "Org"
event_bus_permission_condition = {
   key = "aws:PrincipalOrgID"
   value = "o-fy9yrqr6rv"
   type = "StringEquals"
}

create_event_rule = true 
event_rule_name = "terra-test-eventbus-rule"
event_pattern = { 
   "account": [ "971691587463" ], 
   "source": [ "aws.organizations" ] 
} 

set_event_rule_target = true
target_arn = "arn:aws:lambda:us-east-1:652764719501:function:test"

set_lambda_permisson = true
lambda_function_name = "test"
