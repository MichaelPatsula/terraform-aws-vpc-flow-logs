######
# S3 #
######

resource "aws_s3_bucket" "flow_log_bucket" {
  count = var.log_destination_type == "s3" && var.log_destination == null ? 1 : 0

  bucket_prefix = "${var.name}-vpc-flow-logs-bucket"

  tags = {
    Name = "${var.name}-vpc-flow-logs-bucket"
  }
}

resource "aws_s3_bucket_acl" "flow_log_bucket_acl" {
  count = var.log_destination_type == "s3" && var.log_destination == null ? 1 : 0

  bucket = aws_s3_bucket.flow_log_bucket[0].id
  acl    = "log-delivery-write"
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
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      # The Source ARN must match the region and account of the flow log creator.
      values   = ["arn:aws:logs:*:${data.aws_caller_identity.this.account_id}:*"]
    }
  }

  statement {
    sid    = "AWSLogDeliveryAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.flow_log_bucket[0].arn,
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.this.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:logs:*:${data.aws_caller_identity.this.account_id}:*"]
    }
  }
}
