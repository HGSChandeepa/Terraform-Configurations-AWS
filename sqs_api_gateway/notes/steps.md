# Steps

## 1. Package Lambda Function
```bash
cd lambda
zip webhook_notifier.zip webhook_notifier.js
cd ..
```

## 2. Initialize & Apply
```bash
terraform init
terraform apply -var="webhook_url=https://your-webhook-url.com"
```

## 3. Send Test Message
```bash
curl -X POST https://<api-gateway-url>/prod/sms/normal -d '{"message":"test"}'
```

## 4. Cleanup
```bash
terraform destroy
```