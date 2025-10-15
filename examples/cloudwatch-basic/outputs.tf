# Output the created resources
output "flow_log_id" {
  description = "The ID of the VPC Flow Log"
  value       = module.vpc_flow_logs.aws_flow_log
}

output "cloudwatch_log_group" {
  description = "The CloudWatch Log Group name"
  value       = module.vpc_flow_logs.cloud_watch_log_group
}
