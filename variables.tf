variable "name" {
  description = "The name to use for resources"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to catch the flow logs from"
  type        = string
}

variable "traffic_type" {
  description = " The type of traffic to capture. Values ACCEPT, REJECT, or ALL"
  type        = string
  default     = "REJECT"
}

variable "log_destination_type" {
  description = "Logging destination type. Values cloud-watch-logs or s3 is supported by this module"
  type        = string
  default     = "cloud-watch-logs"
}

variable "destination_options" {
  description = ""
  type = object({
    file_format                = optional(string, "plain-text") // plain-text or parquet - applicable to s3 and firehouse
    hive_compatible_partitions = optional(bool, false)
    per_hour_partition         = optional(bool, false)
  })
  default = {
    file_format = "plain-text"
  }
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

##########################
# CloudWatch Destination #
##########################

variable "log_destination" {
  description = "ARN of the logging destination. If unset (null), the destination will be created for the caller."
  type        = string
  default     = null
}

variable "cloudwatch_destination" {
  description = ""
  type = object({
    retention_in_days = optional(number, 30)
    log_group_class   = optional(string, "STANDARD") # STANDARD, INFREQUENT_ACCESS, or DELIVERY
  })
  default = {}
}
