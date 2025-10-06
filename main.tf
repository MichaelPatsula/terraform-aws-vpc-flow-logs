############
# Flow Log #
############

# Capture information about the IP traffic that goes to and from
# network interfaces in your VPC.
# Module supported destinations: Amazon CloudWatch Logs & Amazon S3
resource "aws_flow_log" "this" {
  # Log which traffic (ACCEPT, REJECT, or ALL)
  traffic_type = var.traffic_type

  # The Flow Log destination is the ARN of the S3 bucket
  log_destination      = var.log_destination != null ? var.log_destination : local.log_destination[var.log_destination_type]
  log_destination_type = var.log_destination_type
  iam_role_arn         = var.log_destination_type == "cloud-watch-logs" ? aws_iam_role.vpc_flow_log_cloudwatch[0].arn : null

  # Target the Flow Log to the entire VPC
  vpc_id = var.vpc_id

  # Optional: Configure logs to use Parquet format and per-hour partitions for Athena optimization
  destination_options {
    file_format        = var.destination_options.file_format
    per_hour_partition = var.destination_options.per_hour_partition
  }

  tags = var.tags
}
