# Basic S3 Destination Example
# This example shows how to create VPC Flow Logs with S3 bucket destination


# VPC Flow Logs with S3 destination
module "vpc_flow_logs" {
  source = "../../"

  name   = "example-vpc"
  vpc_id = data.aws_vpc.default.id

  # S3 configuration
  log_destination_type = "s3"
  traffic_type         = "REJECT"  # Capture only rejected traffic for security analysis

  # S3 destination options (optional)
  destination_options = {
    file_format                = "plain-text"  # or "parquet" for better performance
    hive_compatible_partitions = false
    per_hour_partition         = false
  }

  # Common tags
  tags = {
    Environment = "example"
    Project     = "vpc-flow-logs"
    Owner       = "terraform"
    Purpose     = "security-analysis"
  }
}

