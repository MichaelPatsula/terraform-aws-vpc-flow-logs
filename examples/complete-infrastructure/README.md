# Complete Infrastructure Example

This example demonstrates how to use the VPC Flow Logs module in a real-world scenario by creating a complete VPC infrastructure with multiple flow log configurations.

## What it creates

### VPC Infrastructure
- Custom VPC with DNS support
- Internet Gateway for public access
- Public and private subnets across multiple AZs
- NAT Gateway for private subnet internet access
- Route tables and associations
- Security groups for web and database tiers

### VPC Flow Logs
- **Security Flow Logs**: CloudWatch destination capturing REJECTED traffic for security monitoring
- **Analytics Flow Logs**: S3 destination capturing ALL traffic for comprehensive analysis

## Architecture

```
Internet Gateway
       |
   Public Subnets (10.0.1.0/24, 10.0.2.0/24)
       |
   NAT Gateway
       |
   Private Subnets (10.0.10.0/24, 10.0.20.0/24)
       |
   Database Tier
```

## Flow Log Configuration

### Security Monitoring (CloudWatch)
- **Destination**: CloudWatch Logs
- **Traffic Type**: REJECT only
- **Purpose**: Security analysis and threat detection
- **Retention**: 30 days
- **Log Class**: STANDARD

### Data Analytics (S3)
- **Destination**: S3 bucket
- **Traffic Type**: ALL traffic
- **Purpose**: Comprehensive network analysis
- **Format**: Parquet for better performance
- **Partitioning**: Hive-compatible with hourly partitions

## Usage

1. Update variables in `variables.tf`:
   - Set your preferred AWS region
   - Customize project name and environment
   - Adjust VPC and subnet CIDR blocks if needed

2. Run the following commands:

```bash
terraform init
terraform plan
terraform apply
```

## Security Groups

### Web Security Group
- Allows HTTP (80) and HTTPS (443) from anywhere
- Allows all outbound traffic

### Database Security Group
- Allows MySQL (3306) only from web security group
- Allows all outbound traffic

## Cost Considerations

This example creates:
- NAT Gateway (~$45/month)
- VPC Flow Logs (varies by traffic volume)
- S3 storage for analytics logs

To reduce costs:
- Set `enable_nat_gateway = false` if private subnets don't need internet access
- Use shorter retention periods for CloudWatch logs
- Implement S3 lifecycle policies for analytics logs

## Outputs

- `vpc_id`: ID of the created VPC
- `vpc_cidr_block`: CIDR block of the VPC
- `public_subnet_ids`: IDs of public subnets
- `private_subnet_ids`: IDs of private subnets
- `internet_gateway_id`: ID of the Internet Gateway
- `nat_gateway_id`: ID of the NAT Gateway
- `security_flow_log_id`: ID of the security VPC Flow Log
- `analytics_flow_log_id`: ID of the analytics VPC Flow Log
- `analytics_s3_bucket`: Name of the S3 bucket for analytics

## Use Cases

This complete infrastructure is suitable for:
- **Web Applications**: Multi-tier architecture with public and private subnets
- **Security Monitoring**: Dedicated flow logs for security analysis
- **Data Analytics**: Comprehensive network traffic analysis
- **Compliance**: Meeting regulatory requirements for network monitoring

## Next Steps

After deploying this infrastructure, you can:
1. Launch EC2 instances in the appropriate subnets
2. Set up RDS databases in private subnets
3. Configure CloudWatch alarms for security events
4. Set up Athena queries for S3 flow logs
5. Create custom dashboards for network monitoring

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Note**: This will destroy all resources including the VPC and all associated resources. Make sure to backup any important data before running destroy.
