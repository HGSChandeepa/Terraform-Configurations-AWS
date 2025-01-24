terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Original SQS Queues
resource "aws_sqs_queue" "notification_queues" {
  for_each = { for queue in var.queues : queue => queue }
  
  name                      = each.value
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 345600
}

# Processed Notifications Queue
resource "aws_sqs_queue" "processed_notifications" {
  name = "Processed-Notifications"
}

# API Gateway
resource "aws_api_gateway_rest_api" "notification_api" {
  name        = "notification-api"
  description = "Routes notifications to SQS queues"
}

resource "aws_api_gateway_resource" "sms" {
  rest_api_id = aws_api_gateway_rest_api.notification_api.id
  parent_id   = aws_api_gateway_rest_api.notification_api.root_resource_id
  path_part   = "sms"
}

resource "aws_api_gateway_resource" "email" {
  rest_api_id = aws_api_gateway_rest_api.notification_api.id
  parent_id   = aws_api_gateway_rest_api.notification_api.root_resource_id
  path_part   = "email"
}

# SMS Endpoints
resource "aws_api_gateway_resource" "sms_normal" {
  rest_api_id = aws_api_gateway_rest_api.notification_api.id
  parent_id   = aws_api_gateway_resource.sms.id
  path_part   = "normal"
}

resource "aws_api_gateway_resource" "sms_priority" {
  rest_api_id = aws_api_gateway_rest_api.notification_api.id
  parent_id   = aws_api_gateway_resource.sms.id
  path_part   = "priority"
}

# Email Endpoints
resource "aws_api_gateway_resource" "email_normal" {
  rest_api_id = aws_api_gateway_rest_api.notification_api.id
  parent_id   = aws_api_gateway_resource.email.id
  path_part   = "normal"
}

resource "aws_api_gateway_resource" "email_priority" {
  rest_api_id = aws_api_gateway_rest_api.notification_api.id
  parent_id   = aws_api_gateway_resource.email.id
  path_part   = "priority"
}

# Generic Method Setup
locals {
  routes = {
    "sms/normal"    = aws_sqs_queue.notification_queues["Normal-SMS"].name
    "sms/priority"  = aws_sqs_queue.notification_queues["Priority-SMS"].name
    "email/normal"  = aws_sqs_queue.notification_queues["Normal-Emails"].name
    "email/priority" = aws_sqs_queue.notification_queues["Priority-Emails"].name
  }
}

resource "aws_api_gateway_method" "post_method" {
  for_each      = local.routes

  rest_api_id   = aws_api_gateway_rest_api.notification_api.id
  resource_id   = (each.key == "sms/normal" ? aws_api_gateway_resource.sms_normal.id : 
                  (each.key == "sms/priority" ? aws_api_gateway_resource.sms_priority.id :
                  (each.key == "email/normal" ? aws_api_gateway_resource.email_normal.id :
                   aws_api_gateway_resource.email_priority.id)))
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "sqs_integration" {
  for_each                = local.routes

  rest_api_id             = aws_api_gateway_rest_api.notification_api.id
  resource_id             = (each.key == "sms/normal" ? aws_api_gateway_resource.sms_normal.id :
                           (each.key == "sms/priority" ? aws_api_gateway_resource.sms_priority.id :
                           (each.key == "email/normal" ? aws_api_gateway_resource.email_normal.id :
                           aws_api_gateway_resource.email_priority.id)))
  http_method             = aws_api_gateway_method.post_method[each.key].http_method
  integration_http_method = "POST"
  type                    = "AWS"
  credentials             = aws_iam_role.api_gateway.arn
  uri                     = "arn:aws:apigateway:${var.aws_region}:sqs:path//${each.value}"
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.notification_api.id
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.notification_api.id
  stage_name    = "prod"
}

# Lambda Function
resource "aws_lambda_function" "webhook_notifier" {
  filename      = "lambda/webhook_notifier.zip"
  function_name = "webhook-notifier"
  role          = aws_iam_role.lambda.arn
  handler       = "webhook_notifier.handler"
  runtime       = "nodejs18.x"

  environment {
    variables = {
      WEBHOOK_URL = var.webhook_url
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.processed_notifications.arn
  function_name    = aws_lambda_function.webhook_notifier.arn
  enabled          = true
}