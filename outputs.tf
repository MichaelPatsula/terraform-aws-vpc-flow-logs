output "vpc_flow_logs_bucket_name" {
  description = "The ARN of the S3 bucket storing the VPC Flow Logs"
  value       = aws_s3_bucket.flow_log_bucket[0].id
}

output "cloud_watch_log_group" {
  description = "The ARN of the cloudwatch log group"
  value       = aws_cloudwatch_log_group.vpc_flow_log_cloudwatch[0].id
}

output "aws_flow_log" {
  description = "The AWS flog log ID"
  value       = aws_flow_log.this.id
}
