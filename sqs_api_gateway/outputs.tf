output "api_url" {
  value = "${aws_api_gateway_deployment.deployment.invoke_url}/prod"
}

output "processed_notifications_queue" {
  value = aws_sqs_queue.processed_notifications.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.webhook_notifier.function_name
}
