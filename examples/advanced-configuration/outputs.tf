# Output the created resources
output "cloudwatch_flow_log_id" {
  description = "The ID of the optimized CloudWatch VPC Flow Log"
  value       = module.vpc_flow_logs_cloudwatch_optimized.aws_flow_log
}

output "s3_flow_log_id" {
  description = "The ID of the optimized S3 VPC Flow Log"
  value       = module.vpc_flow_logs_s3_optimized.aws_flow_log
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket with lifecycle policy"
  value       = module.vpc_flow_logs_s3_optimized.vpc_flow_logs_bucket_name
}

output "monitoring_log_group" {
  description = "The CloudWatch Log Group for monitoring"
  value       = aws_cloudwatch_log_group.flow_log_monitoring.name
}
