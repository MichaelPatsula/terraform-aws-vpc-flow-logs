variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ca-central-1"
}

# Example: "arn:aws:logs:us-west-2:123456789012:log-group:existing-vpc-flow-logs"
variable "existing_cloudwatch_log_group_arn" {
  description = "ARN of existing CloudWatch Log Group"
  type        = string
}

# Example: "arn:aws:s3:::existing-vpc-flow-logs-bucket"
variable "existing_s3_bucket_arn" {
  description = "ARN of existing S3 bucket"
  type        = string
}
