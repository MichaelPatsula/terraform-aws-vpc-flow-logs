locals {
    log_destination = {
        s3               = var.log_destination_type == "s3" && var.log_destination == null ? aws_s3_bucket.flow_log_bucket[0].arn : null
        cloud-watch-logs = var.log_destination_type == "cloud-watch-logs" && var.log_destination == null ? aws_cloudwatch_log_group.vpc_flow_log_cloudwatch[0].arn : null
    }
}