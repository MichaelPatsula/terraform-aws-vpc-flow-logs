# CloudWatch Logs Basic Example

This example demonstrates how to create VPC Flow Logs with CloudWatch Logs as the destination.

## What it creates

- VPC Flow Logs configured to capture ALL traffic (both accepted and rejected)
- CloudWatch Log Group with 30-day retention
- IAM role and policy for VPC Flow Logs service
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
- `cloudwatch_log_group`: The name of the CloudWatch Log Group

## Cost Considerations

This example uses:
- CloudWatch Logs with STANDARD class
- 30-day retention period
- Captures ALL traffic (may generate more logs than REJECT only)

For cost optimization, consider:
- Using `traffic_type = "REJECT"` to capture only rejected traffic
- Using `log_group_class = "INFREQUENT_ACCESS"` for cost savings
- Adjusting `retention_in_days` based on your needs
