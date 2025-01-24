terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_sqs_queue" "notification_queues" {
  for_each = { for queue in var.queues : queue => queue }

  name                      = each.value
  delay_seconds             = 0      # Message delivery delay
  max_message_size          = 262144 # 256KB
  message_retention_seconds = 345600 # 4 days
  receive_wait_time_seconds = 0      # Short polling
}
