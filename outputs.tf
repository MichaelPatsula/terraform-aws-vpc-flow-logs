output "vpc_flow_logs_bucket_name" {
  description = "The ARN of the S3 bucket storing the VPC Flow Logs"
  value       = var.log_destination_type == "s3" && var.log_destination == null ?  aws_s3_bucket.flow_log_bucket[0].id : null
}

output "cloud_watch_log_group" {
  description = "The ARN of the cloudwatch log group"
  value       = var.log_destination_type == "cloud-watch-logs" && var.log_destination == null ? aws_cloudwatch_log_group.vpc_flow_log_cloudwatch[0].id : null
}

output "aws_flow_log" {
  description = "The AWS flog log ID"
  value       = aws_flow_log.this.id
}
