# Output the created resources
output "cloudwatch_flow_log_id" {
  description = "The ID of the VPC Flow Log using CloudWatch"
  value       = module.vpc_flow_logs_cloudwatch.aws_flow_log
}

output "s3_flow_log_id" {
  description = "The ID of the VPC Flow Log using S3"
  value       = module.vpc_flow_logs_s3.aws_flow_log
}
