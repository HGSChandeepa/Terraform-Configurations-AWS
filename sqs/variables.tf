variable "queues" {
  description = "List of SQS queues to create"
  type        = list(string)
  default     = [
    "Normal-SMS",
    "Priority-SMS",
    "Normal-Emails",
    "Priority-Emails"
  ]
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "eu-north-1"
}