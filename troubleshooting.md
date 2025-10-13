# VPC Flow Logs CloudWatch Troubleshooting

## Common Issues and Solutions

### Issue: VPC Flow Logs can't send logs to CloudWatch

This error typically occurs due to several possible causes:

#### 1. IAM Role Configuration Issues

**Problem**: The IAM role doesn't have the correct permissions or trust policy.

**Solution**: Ensure the IAM role has:
- Correct trust policy allowing `vpc-flow-logs.amazonaws.com` to assume the role
- Permissions to write to the CloudWatch Log Group
- Proper resource ARN format

#### 2. CloudWatch Log Group Issues

**Problem**: The log group doesn't exist or has incorrect configuration.

**Solution**: Verify:
- Log group exists before creating the flow log
- Log group has appropriate retention settings
- Log group class is set (STANDARD, INFREQUENT_ACCESS, or DELIVERY)

#### 3. Resource Dependencies

**Problem**: Flow log is created before the CloudWatch log group or IAM role.

**Solution**: Ensure proper resource dependencies:
- CloudWatch log group is created first
- IAM role and policy are created before the flow log
- Use `depends_on` if necessary

#### 4. Region and Account Issues

**Problem**: Resources are in different regions or accounts.

**Solution**: Verify:
- All resources are in the same AWS region
- IAM role is in the same account as the VPC
- CloudWatch log group is in the same region as the VPC

## Fixed Issues in This Module

### 1. IAM Policy Resource ARN
**Fixed**: Changed from specific log stream pattern to broader log group access:
```hcl
# Before (incorrect)
Resource = "${aws_cloudwatch_log_group.vpc_flow_log_cloudwatch[0].arn}:/aws/vpc/flowlogs/${var.name}-vpc:*"

# After (correct)
Resource = "${aws_cloudwatch_log_group.vpc_flow_log_cloudwatch[0].arn}:*"
```

### 2. IAM Role ARN Logic
**Fixed**: Added condition to only set IAM role when creating new CloudWatch log group:
```hcl
# Before (incorrect)
iam_role_arn = var.log_destination_type == "cloud-watch-logs" ? aws_iam_role.vpc_flow_log_cloudwatch[0].arn : null

# After (correct)
iam_role_arn = var.log_destination_type == "cloud-watch-logs" && var.log_destination == null ? aws_iam_role.vpc_flow_log_cloudwatch[0].arn : null
```

### 3. CloudWatch Log Group Class Default
**Fixed**: Added default value for log group class:
```hcl
# Before (could be null)
log_group_class = optional(string)

# After (has default)
log_group_class = optional(string, "STANDARD")
```

### 4. S3: AccessControlListNotSupported / "The bucket does not allow ACLs"
**Symptoms**: Terraform apply fails with `AccessControlListNotSupported: The bucket does not allow ACLs` when creating the flow logs S3 bucket.

**Cause**: Your account or bucket enforces S3 Object Ownership = Bucket owner enforced (BucketOwnerEnforced), which disables ACLs.

**Resolution**:
- Module now configures ownership controls:
```hcl
resource "aws_s3_bucket_ownership_controls" "flow_log_bucket_ownership" {
  bucket = aws_s3_bucket.flow_log_bucket[0].id
  rule { object_ownership = "BucketOwnerEnforced" }
}
```
- Removed use of `aws_s3_bucket_acl` and the `s3:x-amz-acl` condition from the bucket policy.
- Bucket policy continues to allow `delivery.logs.amazonaws.com` with `ArnLike aws:SourceArn` and `StringEquals aws:SourceAccount` conditions.

If you manage the bucket externally with ownership enforced, pass its ARN via `var.log_destination` and the module will skip bucket creation.

## Testing the Configuration

### 1. Validate Terraform Configuration
```bash
terraform init
terraform validate
terraform plan
```

### 2. Check AWS Resources
After applying, verify:
- CloudWatch log group exists
- IAM role has correct trust policy
- IAM policy has correct permissions
- VPC flow log is active

### 3. Monitor CloudWatch Logs
- Check if log streams are being created
- Look for any error messages in CloudWatch
- Verify log events are being written

## Example Working Configuration

```hcl
module "vpc_flow_logs" {
  source = "path/to/this/module"

  name   = "my-vpc"
  vpc_id = "vpc-12345678"
  
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  
  cloudwatch_destination = {
    retention_in_days = 30
    log_group_class   = "STANDARD"
  }
  
  tags = {
    Environment = "production"
    Project     = "networking"
  }
}
```

## Debugging Steps

1. **Check Terraform State**: `terraform show`
2. **Verify AWS Console**: Check CloudWatch Logs and IAM
3. **Review CloudTrail**: Look for any permission errors
4. **Test IAM Permissions**: Use AWS CLI to test role permissions
5. **Check VPC Flow Logs Status**: Verify in AWS Console

## Additional Resources

- [AWS VPC Flow Logs Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html)
- [CloudWatch Logs IAM Permissions](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/iam-identity-based-access-control-cwl.html)
- [VPC Flow Logs Troubleshooting](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs-troubleshooting.html)
