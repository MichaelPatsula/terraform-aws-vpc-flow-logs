######
# S3 #
######

resource "aws_s3_bucket" "flow_log_bucket" {
  count = var.log_destination_type == "s3" && var.log_destination == null ? 1 : 0

  bucket_prefix = "${var.name}-vpc-fl"

  tags = {
    Name = "${var.name}-vpc-flow-logs"
  }

  timeouts {
    create = "5m"
    delete = "5m"
  }
}

resource "aws_s3_bucket_ownership_controls" "flow_log_bucket_ownership" {
  count = var.log_destination_type == "s3" && var.log_destination == null ? 1 : 0

  bucket = aws_s3_bucket.flow_log_bucket[0].id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_policy" "flow_log_bucket_policy" {
  count = var.log_destination_type == "s3" && var.log_destination == null ? 1 : 0

  bucket = aws_s3_bucket.flow_log_bucket[0].id
  policy = data.aws_iam_policy_document.flow_log_s3_policy[0].json
}

# S3 Bucket Policy (to grant the AWS service permission to write logs)
# The bucket policy is critical for VPC flow logs to S3.
data "aws_iam_policy_document" "flow_log_s3_policy" {
  count = var.log_destination_type == "s3" && var.log_destination == null ? 1 : 0

  statement {
    sid    = "AWSLogDeliveryWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.flow_log_bucket[0].arn}/*",
    ]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      # The Source ARN must match the region and account of the flow log creator.
      values = ["arn:aws:logs:*:${data.aws_caller_identity.this.account_id}:*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.this.account_id]
    }
  }
}
