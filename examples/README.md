# Examples

This directory contains practical examples demonstrating how to use the Terraform AWS VPC Flow Logs module in various scenarios.

## Available Examples

### 1. [CloudWatch Basic](./cloudwatch-basic/)
Simple example showing how to create VPC Flow Logs with CloudWatch Logs destination.

**Features:**
- Basic CloudWatch Logs configuration
- 30-day retention
- Captures ALL traffic
- Uses default VPC

**Use Case:** Quick setup for development or testing environments.

### 2. [S3 Basic](./s3-basic/)
Simple example showing how to create VPC Flow Logs with S3 bucket destination.

**Features:**
- Basic S3 configuration
- Plain text format
- Captures REJECTED traffic only
- Uses default VPC

**Use Case:** Long-term log storage and archival.

### 3. [Existing Destination](./existing-destination/)
Example showing how to use the module with existing CloudWatch Log Groups or S3 buckets.

**Features:**
- Uses existing CloudWatch Log Group
- Uses existing S3 bucket
- No new destination resources created
- Demonstrates both destination types

**Use Case:** Integration with existing logging infrastructure.

### 4. [Advanced Configuration](./advanced-configuration/)
Advanced example with cost optimization and performance tuning.

**Features:**
- Cost-optimized CloudWatch configuration
- Performance-optimized S3 configuration
- S3 lifecycle policies
- Monitoring infrastructure

**Use Case:** Production environments with cost and performance requirements.

### 5. [Complete Infrastructure](./complete-infrastructure/)
Complete VPC infrastructure with multiple flow log configurations.

**Features:**
- Full VPC with public/private subnets
- NAT Gateway
- Security groups
- Multiple flow log configurations
- Real-world architecture

**Use Case:** Production applications requiring comprehensive network monitoring.

## Prerequisites

Before running any example:

1. **AWS CLI configured** with appropriate credentials
2. **Terraform installed** (version >= 1.0)
3. **AWS Provider** (version >= 4.0)
4. **Appropriate AWS permissions** for VPC, CloudWatch, and S3 resources

## Quick Start

1. Choose an example that matches your use case
2. Navigate to the example directory
3. Review and update variables as needed
4. Run the following commands:

```bash
terraform init
terraform plan
terraform apply
```

## Cost Considerations

### CloudWatch Logs
- Pay per GB ingested and stored
- Consider retention periods and log classes
- REJECT traffic only reduces volume significantly

### S3 Storage
- Pay for storage and requests
- Parquet format reduces storage costs
- Lifecycle policies provide automatic cost optimization

### NAT Gateway
- Fixed monthly cost (~$45/month)
- Data processing charges apply
- Consider VPC endpoints for cost optimization

## Security Best Practices

All examples implement security best practices:

- **Least Privilege IAM**: Minimal required permissions
- **Resource Tagging**: Proper resource identification
- **Network Segmentation**: Public/private subnet separation
- **Security Groups**: Restrictive access rules

## Monitoring and Alerting

Consider implementing:

- CloudWatch alarms for flow log failures
- S3 access logging for audit trails
- Custom dashboards for network visibility
- Automated responses to security events

## Troubleshooting

Common issues and solutions:

### Flow Logs Not Appearing
- Check IAM permissions
- Verify VPC ID is correct
- Ensure destination exists and is accessible

### High Costs
- Review traffic type (use REJECT instead of ALL)
- Adjust retention periods
- Implement S3 lifecycle policies

### Performance Issues
- Use Parquet format for S3
- Enable partitioning
- Consider log group classes

## Contributing

To add new examples:
1. Create a new directory under `examples/`
2. Include `main.tf`, `variables.tf`, and `README.md`
3. Follow the existing naming conventions
4. Document the use case and features
5. Test the example thoroughly
