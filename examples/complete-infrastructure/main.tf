# Complete Infrastructure Example
# This example creates a complete VPC with flow logs, demonstrating real-world usage

module "vpc" {
  source               = "../../../aws-vpc"
  name                 = "gen-canary-cc-00"
  cidr_blocks          = ["172.26.0.0/16", "172.27.0.0/16"]
  availability_zones   = [data.aws_availability_zones.this.zone_ids[0], data.aws_availability_zones.this.zone_ids[1]]
  enable_dns_hostnames = true
  single_nat_gateway   = true

  subnets = {
    "transit-gateway" = {
      cidr_blocks        = ["172.26.1.0/24", "172.26.2.0/24"]
      subnet_type        = "public"
      create_nat_gateway = true
    },
    "loadbalancer" = {
      cidr_blocks = ["172.26.4.0/24", "172.26.5.0/24"]
    },
    "node-pools" = {
      cidr_blocks             = ["172.26.7.0/24", "172.26.8.0/24"]
      prefix_cidr_reservation = ["172.26.7.128/25", "172.26.8.128/25"]
    },
    "infrastructure" = {
      cidr_blocks       = ["172.26.10.0/24", "172.26.11.0/24"]
      gateway_endpoints = { s3 = {} }
    }
  }
}

# VPC Flow Logs for security monitoring
module "vpc_flow_logs_security" {
  source = "../../"

  name   = "${var.project_name}-security"
  vpc_id = module.vpc.vpc.id

  # Security-focused configuration
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "REJECT" # Focus on rejected traffic for security analysis

  cloudwatch_destination = {
    retention_in_days = 30
    log_group_class   = "STANDARD"
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Purpose     = "security-monitoring"
    Owner       = "security-team"
  }
}

# VPC Flow Logs for comprehensive analysis
module "vpc_flow_logs_analytics" {
  source = "../../"

  name   = "${var.project_name}-analytics"
  vpc_id = module.vpc.vpc.id

  # Analytics-focused configuration
  log_destination_type = "s3"
  traffic_type         = "ALL" # Capture all traffic for comprehensive analysis

  destination_options = {
    file_format                = "parquet"
    hive_compatible_partitions = true
    per_hour_partition         = true
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Purpose     = "data-analytics"
    Owner       = "analytics-team"
  }
}


