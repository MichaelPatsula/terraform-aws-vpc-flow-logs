# Advanced Configuration Example

This example demonstrates advanced configuration options for VPC Flow Logs, including cost optimization, performance tuning, and lifecycle management.

## What it creates

### CloudWatch Optimized Configuration
- VPC Flow Logs with CloudWatch Logs destination
- INFREQUENT_ACCESS log class for cost savings
- 7-day retention period
- Only captures REJECTED traffic to minimize log volume

### S3 Optimized Configuration
- VPC Flow Logs with S3 destination
- Parquet file format for better compression and query performance
- Hive-compatible partitioning
- Hourly partitions for improved query performance
- S3 lifecycle policy for automatic cost optimization

### Additional Resources
- CloudWatch Log Group for monitoring flow log activity
- S3 lifecycle configuration for automatic archival and deletion

## Cost Optimization Features

### CloudWatch Optimizations
- **INFREQUENT_ACCESS class**: 50% cost reduction for storage
- **Short retention**: 7 days instead of default 30 days
- **REJECT traffic only**: Reduces log volume by ~80-90%

### S3 Optimizations
- **Parquet format**: Better compression (typically 60-80% smaller files)
- **Lifecycle policy**: Automatic transitions to cheaper storage classes
- **Automatic cleanup**: Removes incomplete uploads and old data

## Performance Features

### S3 Performance
- **Parquet format**: Columnar storage for faster queries
- **Hive partitioning**: Compatible with analytics tools
- **Hourly partitions**: Better query performance for time-based analysis

## Usage

1. Update the `aws_region` variable in `variables.tf` if needed
2. Run the following commands:

```bash
terraform init
terraform plan
terraform apply
```

## S3 Lifecycle Policy

The lifecycle policy automatically:
- Transitions to Standard-IA after 30 days (40% cost savings)
- Transitions to Glacier after 90 days (68% cost savings)
- Deletes data after 1 year
- Cleans up incomplete multipart uploads after 7 days

## Monitoring

The example creates a separate CloudWatch Log Group for monitoring flow log activity, which can be used for:
- Alerting on flow log failures
- Monitoring log delivery metrics
- Tracking flow log configuration changes

## Outputs

- `cloudwatch_flow_log_id`: The ID of the optimized CloudWatch VPC Flow Log
- `s3_flow_log_id`: The ID of the optimized S3 VPC Flow Log
- `s3_bucket_name`: The name of the S3 bucket with lifecycle policy
- `monitoring_log_group`: The CloudWatch Log Group for monitoring

## Cost Comparison

| Configuration | Monthly Cost (estimated) | Use Case |
|---------------|-------------------------|----------|
| Standard CloudWatch (30 days, ALL traffic) | $100-500 | Development |
| Optimized CloudWatch (7 days, REJECT only) | $10-50 | Production |
| S3 with lifecycle | $5-20 | Long-term storage |

*Costs vary based on traffic volume and region*

## Best Practices Demonstrated

1. **Cost Optimization**: Use appropriate log classes and retention periods
2. **Performance**: Use Parquet format and partitioning for analytics
3. **Lifecycle Management**: Automatic archival and cleanup
4. **Monitoring**: Separate monitoring infrastructure
5. **Traffic Filtering**: Capture only necessary traffic types
