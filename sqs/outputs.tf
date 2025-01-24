output "queue_urls" {
  description = "URLs of the created SQS queues"
  value       = { for k, v in aws_sqs_queue.notification_queues : k => v.url }
}

output "queue_arns" {
  description = "ARNs of the created SQS queues"
  value       = { for k, v in aws_sqs_queue.notification_queues : k => v.arn }
}