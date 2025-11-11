################################################################################
# DynamoDB Table Outputs
################################################################################

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = module.dynamodb_table.dynamodb_table_arn
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = module.dynamodb_table.dynamodb_table_name
}

output "dynamodb_table_hash_key" {
  description = "Hash key of the DynamoDB table"
  value       = module.dynamodb_table.dynamodb_table_hash_key
}

output "dynamodb_table_billing_mode" {
  description = "Billing mode of the DynamoDB table"
  value       = module.dynamodb_table.dynamodb_table_billing_mode
}
