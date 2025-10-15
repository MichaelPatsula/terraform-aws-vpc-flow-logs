# Advanced Configuration Example
# This example shows advanced configuration options including cost optimization and performance tuning


# Advanced CloudWatch configuration with cost optimization
module "vpc_flow_logs_cloudwatch_optimized" {
  source = "../../"

  name   = "advanced-cloudwatch"
  vpc_id = data.aws_vpc.default.id

  # CloudWatch configuration with cost optimization
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "REJECT" # Only capture rejected traffic to reduce costs

  # Advanced CloudWatch settings
  cloudwatch_destination = {
    retention_in_days = 7                   # Short retention for cost savings
    log_group_class   = "INFREQUENT_ACCESS" # Cost-optimized log class
  }

  tags = {
    Environment = "production"
    Project     = "vpc-flow-logs"
    Owner       = "terraform"
    CostCenter  = "security"
    Purpose     = "security-monitoring"
  }
}

# Advanced S3 configuration with performance optimization
module "vpc_flow_logs_s3_optimized" {
  source = "../../"

  name   = "advanced-s3"
  vpc_id = data.aws_vpc.default.id

  # S3 configuration with performance optimization
  log_destination_type = "s3"
  traffic_type         = "ALL" # Capture all traffic for comprehensive analysis

  # Advanced S3 destination options
  destination_options = {
    file_format                = "parquet" # Columnar format for better performance
    hive_compatible_partitions = true      # Enable Hive-compatible partitioning
    per_hour_partition         = true      # Hourly partitions for better query performance
  }

  tags = {
    Environment = "production"
    Project     = "vpc-flow-logs"
    Owner       = "terraform"
    CostCenter  = "analytics"
    Purpose     = "data-analytics"
  }
}

# S3 Lifecycle Policy for cost optimization
resource "aws_s3_bucket_lifecycle_configuration" "flow_logs_lifecycle" {
  bucket = module.vpc_flow_logs_s3_optimized.vpc_flow_logs_bucket_name

  rule {
    id     = "flow_logs_lifecycle"
    status = "Enabled"

    # Transition to IA after 30 days
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    # Transition to Glacier after 90 days
    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    # Delete after 1 year
    expiration {
      days = 365
    }

    # Clean up incomplete multipart uploads
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# CloudWatch Log Group for monitoring flow log activity
resource "aws_cloudwatch_log_group" "flow_log_monitoring" {
  name              = "vpc-flow-logs-monitoring"
  retention_in_days = 14
  log_group_class   = "STANDARD"

  tags = {
    Environment = "production"
    Project     = "vpc-flow-logs"
    Purpose     = "monitoring"
  }
}
