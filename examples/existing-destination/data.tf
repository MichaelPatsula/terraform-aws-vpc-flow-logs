# Data source to get the default VPC
data "aws_vpc" "default" {
  default = true
}
