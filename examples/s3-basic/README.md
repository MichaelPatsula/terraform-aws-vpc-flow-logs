# S3 Basic Example

This example demonstrates how to create VPC Flow Logs with S3 bucket as the destination.

## What it creates

- VPC Flow Logs configured to capture REJECTED traffic only
- S3 bucket with proper permissions for AWS log delivery service
- S3 bucket policy allowing log delivery
- All resources tagged appropriately

## Usage

1. Update the `aws_region` variable in `variables.tf` if needed
2. Run the following commands:

```bash
terraform init
terraform plan
terraform apply
```

## Outputs

- `flow_log_id`: The ID of the created VPC Flow Log
- `s3_bucket_name`: The name of the S3 bucket storing flow logs

## S3 Configuration Options

The example uses these S3 destination options:
- `file_format = "plain-text"`: Human-readable format
- `hive_compatible_partitions = false`: Standard partitioning
- `per_hour_partition = false`: Daily partitions

## Cost Optimization

For better performance and cost optimization with S3:
- Use `file_format = "parquet"` for compressed, columnar format
- Enable `per_hour_partition = true` for better query performance
- Consider S3 lifecycle policies for automatic archival

## Querying Flow Logs

Once logs are in S3, you can:
- Use AWS Athena to query the logs
- Set up CloudWatch Insights for real-time analysis
- Create custom dashboards and alerts
