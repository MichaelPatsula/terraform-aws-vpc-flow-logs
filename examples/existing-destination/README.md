# Existing Destination Example

This example demonstrates how to use the VPC Flow Logs module with existing CloudWatch Log Groups or S3 buckets.

## What it creates

- Two VPC Flow Logs configurations:
  1. One using an existing CloudWatch Log Group
  2. One using an existing S3 bucket
- No new destination resources are created (the module skips creation when `log_destination` is provided)

## Prerequisites

Before running this example, you need:

1. **For CloudWatch example**: An existing CloudWatch Log Group with proper IAM permissions
2. **For S3 example**: An existing S3 bucket with proper bucket policy for AWS log delivery

## Usage

1. Update the variables in `variables.tf`:
   - Set `existing_cloudwatch_log_group_arn` to your CloudWatch Log Group ARN
   - Set `existing_s3_bucket_arn` to your S3 bucket ARN
   - Update `aws_region` if needed

2. Run the following commands:

```bash
terraform init
terraform plan
terraform apply
```

## Important Notes

### CloudWatch Log Group Requirements
The existing CloudWatch Log Group must have:
- Proper IAM role attached to VPC Flow Logs service
- IAM policy allowing `logs:CreateLogStream` and `logs:PutLogEvents`
- Appropriate permissions for the VPC Flow Logs service

### S3 Bucket Requirements
The existing S3 bucket must have:
- Bucket policy allowing AWS log delivery service to write
- Proper ACL or bucket policy for log delivery
- Permissions for `delivery.logs.amazonaws.com` service

## Outputs

- `cloudwatch_flow_log_id`: The ID of the VPC Flow Log using CloudWatch
- `s3_flow_log_id`: The ID of the VPC Flow Log using S3

## Use Cases

This pattern is useful when:
- You have centralized logging infrastructure
- You want to reuse existing S3 buckets for cost optimization
- You have compliance requirements for log storage
- You want to separate log destination management from flow log configuration
