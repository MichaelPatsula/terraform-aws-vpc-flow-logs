# Output the created resources
output "flow_log_id" {
  description = "The ID of the VPC Flow Log"
  value       = module.vpc_flow_logs.aws_flow_log
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket storing flow logs"
  value       = module.vpc_flow_logs.vpc_flow_logs_bucket_name
}
