variable "queues" {
  description = "List of main SQS queues to create"
  type        = list(string)
  default     = [
    "Normal-SMS",
    "Priority-SMS",
    "Normal-Emails",
    "Priority-Emails"
  ]
}

variable "webhook_url" {
  description = "URL to notify when messages are processed"
  type        = string
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}