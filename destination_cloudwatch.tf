##############
# CloudWatch #
##############

# Centralized Logging: Aggregate logs from all your systems and applications in one place.
# Log Streams: Within a log group, logs are organized into "log streams." A log stream is a sequence of log events that share the same source (e.g., all logs from a specific EC2 instance or all flow logs from a particular ENI).
resource "aws_cloudwatch_log_group" "vpc_flow_log_cloudwatch" {
  count = var.log_destination_type == "cloud-watch-logs" && var.log_destination == null ? 1 : 0

  name_prefix = "${var.name}-vpc-fl"

  retention_in_days = var.cloudwatch_destination.retention_in_days   
  log_group_class   = var.cloudwatch_destination.log_group_class                # STANDARD or INFREQUENT_ACCESS

  tags = var.tags
}

##  Role Policy Attachment ##

resource "aws_iam_role_policy_attachment" "vpc_flow_log_cloudwatch" {
  count = var.log_destination_type == "cloud-watch-logs" && var.log_destination == null ? 1 : 0

  role       = aws_iam_role.vpc_flow_log_cloudwatch[0].name
  policy_arn = aws_iam_policy.vpc_flow_log_cloudwatch[0].arn
}


resource "aws_iam_role" "vpc_flow_log_cloudwatch" {
  count = var.log_destination_type == "cloud-watch-logs" && var.log_destination == null ? 1 : 0

  name = "${var.name}-vpc-flow-log"
  description = "VPC Flow Logs using CloudWatch"  

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "VPCFlowLogsAssumeRole"
        Effect = "Allow"
        Action = ["sts:AssumeRole"]
        Principal = {
          Service = ["vpc-flow-logs.amazonaws.com"]
        }
      }
    ]    
  })

  tags = var.tags
}

resource "aws_iam_policy" "vpc_flow_log_cloudwatch" {
  count = var.log_destination_type == "cloud-watch-logs" && var.log_destination == null ? 1 : 0

  name_prefix = "${var.name}-vpc-flow-log-cloudwatch"
  description = "VPC Flow Logs using CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Permissions to create log streams and put log events within the specific log group
      {
        Sid    = "VPCFlowLogsPushToCloudWatchStreamsAndEvents"
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Resource = "${aws_cloudwatch_log_group.vpc_flow_log_cloudwatch[0].arn}:*"
      },
      # (Optional) Describe actions for broader policy, often not strictly needed for service role
      # For strict least privilege, you might omit these for the flow log service role.
      # If included, typically they can be on all resources or specific ones if needed.
      {
        Sid    = "VPCFlowLogsDescribeCloudWatch"
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "${aws_cloudwatch_log_group.vpc_flow_log_cloudwatch[0].arn}:*"
      }
    ]
  })

  tags = var.tags
}
