output "security_flow_log_id" {
  description = "ID of the security VPC Flow Log"
  value       = module.vpc_flow_logs_security.aws_flow_log
}

output "analytics_flow_log_id" {
  description = "ID of the analytics VPC Flow Log"
  value       = module.vpc_flow_logs_analytics.aws_flow_log
}

output "analytics_s3_bucket" {
  description = "Name of the S3 bucket for analytics"
  value       = module.vpc_flow_logs_analytics.vpc_flow_logs_bucket_name
}
