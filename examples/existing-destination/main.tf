# Existing Destination Example
# This example shows how to use the module with existing CloudWatch Log Group or S3 bucket


# Example 1: Using existing CloudWatch Log Group
module "vpc_flow_logs_cloudwatch" {
  source = "../../"

  name   = "example-vpc-cloudwatch"
  vpc_id = data.aws_vpc.default.id

  # Use existing CloudWatch Log Group
  log_destination_type = "cloud-watch-logs"
  log_destination      = var.existing_cloudwatch_log_group_arn
  traffic_type         = "ALL"

  tags = {
    Environment = "example"
    Project     = "vpc-flow-logs"
    Owner       = "terraform"
    Type        = "existing-cloudwatch"
  }
}

# Example 2: Using existing S3 bucket
module "vpc_flow_logs_s3" {
  source = "../../"

  name   = "example-vpc-s3"
  vpc_id = data.aws_vpc.default.id

  # Use existing S3 bucket
  log_destination_type = "s3"
  log_destination      = var.existing_s3_bucket_arn
  traffic_type         = "REJECT"

  tags = {
    Environment = "example"
    Project     = "vpc-flow-logs"
    Owner       = "terraform"
    Type        = "existing-s3"
  }
}

