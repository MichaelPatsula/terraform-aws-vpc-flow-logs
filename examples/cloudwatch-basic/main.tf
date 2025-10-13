# Basic CloudWatch Logs Example
# This example shows how to create VPC Flow Logs with CloudWatch Logs destination


# VPC Flow Logs with CloudWatch Logs destination
module "vpc_flow_logs" {
  source = "../../"

  name   = "example-vpc"
  vpc_id = data.aws_vpc.default.id

  # CloudWatch Logs configuration
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL" # Capture all traffic (ACCEPT and REJECT)

  # CloudWatch specific settings
  cloudwatch_destination = {
    retention_in_days = 30
    log_group_class   = "STANDARD"
  }

  # Common tags
  tags = {
    Environment = "example"
    Project     = "vpc-flow-logs"
    Owner       = "terraform"
  }
}

