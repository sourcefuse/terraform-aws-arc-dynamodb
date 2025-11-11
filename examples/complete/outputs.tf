################################################################################
# DynamoDB Table Outputs
################################################################################

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = module.dynamodb_table.dynamodb_table_arn
}

output "dynamodb_table_id" {
  description = "ID of the DynamoDB table"
  value       = module.dynamodb_table.dynamodb_table_id
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = module.dynamodb_table.dynamodb_table_name
}

output "dynamodb_table_stream_arn" {
  description = "ARN of the DynamoDB table stream"
  value       = module.dynamodb_table.dynamodb_table_stream_arn
}

output "dynamodb_table_stream_label" {
  description = "Timestamp, in ISO 8601 format, for this stream"
  value       = module.dynamodb_table.dynamodb_table_stream_label
}

output "dynamodb_table_global_secondary_index_names" {
  description = "List of global secondary index names"
  value       = module.dynamodb_table.dynamodb_table_global_secondary_index_names
}

output "dynamodb_table_local_secondary_index_names" {
  description = "List of local secondary index names"
  value       = module.dynamodb_table.dynamodb_table_local_secondary_index_names
}
