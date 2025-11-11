#################################################################################
# DynamoDB Table
#################################################################################

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = try(aws_dynamodb_table.this.arn, null)
}

output "dynamodb_table_id" {
  description = "ID of the DynamoDB table"
  value       = try(aws_dynamodb_table.this.id, null)
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = try(aws_dynamodb_table.this.name, null)
}

output "dynamodb_table_billing_mode" {
  description = "Billing mode of the DynamoDB table"
  value       = try(aws_dynamodb_table.this.billing_mode, null)
}

output "dynamodb_table_hash_key" {
  description = "Hash key of the DynamoDB table"
  value       = try(aws_dynamodb_table.this.hash_key, null)
}

output "dynamodb_table_range_key" {
  description = "Range key of the DynamoDB table"
  value       = try(aws_dynamodb_table.this.range_key, null)
}

output "dynamodb_table_read_capacity" {
  description = "Read capacity of the DynamoDB table"
  value       = try(aws_dynamodb_table.this.read_capacity, null)
}

output "dynamodb_table_write_capacity" {
  description = "Write capacity of the DynamoDB table"
  value       = try(aws_dynamodb_table.this.write_capacity, null)
}

output "dynamodb_table_table_class" {
  description = "Storage class of the DynamoDB table"
  value       = try(aws_dynamodb_table.this.table_class, null)
}

#################################################################################
# DynamoDB Stream
#################################################################################

output "dynamodb_table_stream_arn" {
  description = "ARN of the DynamoDB table stream"
  value       = try(aws_dynamodb_table.this.stream_arn, null)
}

output "dynamodb_table_stream_label" {
  description = "Timestamp, in ISO 8601 format, for this stream"
  value       = try(aws_dynamodb_table.this.stream_label, null)
}

output "dynamodb_table_stream_view_type" {
  description = "When an item in the table is modified, StreamViewType determines what information is written to the table's stream"
  value       = try(aws_dynamodb_table.this.stream_view_type, null)
}

#################################################################################
# DynamoDB Global Secondary Indexes
#################################################################################

output "dynamodb_table_global_secondary_indexes" {
  description = "List of global secondary indexes and their attributes"
  value = try([
    for gsi in aws_dynamodb_table.this.global_secondary_index : {
      name            = gsi.name
      hash_key        = gsi.hash_key
      range_key       = gsi.range_key
      projection_type = gsi.projection_type
      read_capacity   = gsi.read_capacity
      write_capacity  = gsi.write_capacity
    }
  ], [])
}

output "dynamodb_table_global_secondary_index_names" {
  description = "List of global secondary index names"
  value       = try([for gsi in aws_dynamodb_table.this.global_secondary_index : gsi.name], [])
}

#################################################################################
# DynamoDB Local Secondary Indexes
#################################################################################

output "dynamodb_table_local_secondary_indexes" {
  description = "List of local secondary indexes and their attributes"
  value = try([
    for lsi in aws_dynamodb_table.this.local_secondary_index : {
      name            = lsi.name
      range_key       = lsi.range_key
      projection_type = lsi.projection_type
    }
  ], [])
}

output "dynamodb_table_local_secondary_index_names" {
  description = "List of local secondary index names"
  value       = try([for lsi in aws_dynamodb_table.this.local_secondary_index : lsi.name], [])
}

#################################################################################
# DynamoDB Attributes
#################################################################################

output "dynamodb_table_attributes" {
  description = "List of table attributes"
  value = try([
    for attr in aws_dynamodb_table.this.attribute : {
      name = attr.name
      type = attr.type
    }
  ], [])
}

#################################################################################
# DynamoDB TTL
#################################################################################

output "dynamodb_table_ttl" {
  description = "TTL configuration of the DynamoDB table"
  value = try({
    enabled        = aws_dynamodb_table.this.ttl[0].enabled
    attribute_name = aws_dynamodb_table.this.ttl[0].attribute_name
  }, null)
}

#################################################################################
# DynamoDB Server Side Encryption
#################################################################################

output "dynamodb_table_server_side_encryption" {
  description = "Server side encryption configuration of the DynamoDB table"
  value = try({
    enabled = aws_dynamodb_table.this.server_side_encryption[0].enabled
  }, null)
}

#################################################################################
# DynamoDB Point In Time Recovery
#################################################################################

output "dynamodb_table_point_in_time_recovery" {
  description = "Point in time recovery configuration of the DynamoDB table"
  value = try({
    enabled = aws_dynamodb_table.this.point_in_time_recovery[0].enabled
  }, null)
}

#################################################################################
# DynamoDB Replicas
#################################################################################

output "dynamodb_table_replicas" {
  description = "List of replicas of the DynamoDB table"
  value = try([
    for replica in aws_dynamodb_table.this.replica : {
      region_name                    = replica.region_name
      kms_key_arn                    = replica.kms_key_arn
      point_in_time_recovery_enabled = replica.point_in_time_recovery_enabled
      propagate_tags                 = replica.propagate_tags
    }
  ], [])
}

#################################################################################
# DynamoDB Tags
#################################################################################

output "dynamodb_table_tags" {
  description = "Tags of the DynamoDB table"
  value       = try(aws_dynamodb_table.this.tags_all, {})
}

#################################################################################
# DynamoDB Contributor Insights
#################################################################################

output "dynamodb_table_contributor_insights_status" {
  description = "Status of contributor insights on the table"
  value       = try(aws_dynamodb_contributor_insights.table[0].id, null)
}

output "dynamodb_gsi_contributor_insights_status" {
  description = "Status of contributor insights on GSI"
  value       = { for k, v in aws_dynamodb_contributor_insights.gsi : k => v.id }
}

#################################################################################
# Autoscaling Targets
#################################################################################

output "dynamodb_table_autoscaling_read_target" {
  description = "Autoscaling read target for the table"
  value = try({
    arn                = aws_appautoscaling_target.table_read[0].arn
    max_capacity       = aws_appautoscaling_target.table_read[0].max_capacity
    min_capacity       = aws_appautoscaling_target.table_read[0].min_capacity
    resource_id        = aws_appautoscaling_target.table_read[0].resource_id
    scalable_dimension = aws_appautoscaling_target.table_read[0].scalable_dimension
    service_namespace  = aws_appautoscaling_target.table_read[0].service_namespace
  }, null)
}

output "dynamodb_table_autoscaling_write_target" {
  description = "Autoscaling write target for the table"
  value = try({
    arn                = aws_appautoscaling_target.table_write[0].arn
    max_capacity       = aws_appautoscaling_target.table_write[0].max_capacity
    min_capacity       = aws_appautoscaling_target.table_write[0].min_capacity
    resource_id        = aws_appautoscaling_target.table_write[0].resource_id
    scalable_dimension = aws_appautoscaling_target.table_write[0].scalable_dimension
    service_namespace  = aws_appautoscaling_target.table_write[0].service_namespace
  }, null)
}

output "dynamodb_gsi_autoscaling_read_targets" {
  description = "Autoscaling read targets for GSI"
  value = {
    for k, v in aws_appautoscaling_target.gsi_read : k => {
      arn                = v.arn
      max_capacity       = v.max_capacity
      min_capacity       = v.min_capacity
      resource_id        = v.resource_id
      scalable_dimension = v.scalable_dimension
      service_namespace  = v.service_namespace
    }
  }
}

output "dynamodb_gsi_autoscaling_write_targets" {
  description = "Autoscaling write targets for GSI"
  value = {
    for k, v in aws_appautoscaling_target.gsi_write : k => {
      arn                = v.arn
      max_capacity       = v.max_capacity
      min_capacity       = v.min_capacity
      resource_id        = v.resource_id
      scalable_dimension = v.scalable_dimension
      service_namespace  = v.service_namespace
    }
  }
}

#################################################################################
# Autoscaling Policies
#################################################################################

output "dynamodb_table_autoscaling_read_policy_arn" {
  description = "ARN of autoscaling read policy for the table"
  value       = try(aws_appautoscaling_policy.table_read[0].arn, null)
}

output "dynamodb_table_autoscaling_write_policy_arn" {
  description = "ARN of autoscaling write policy for the table"
  value       = try(aws_appautoscaling_policy.table_write[0].arn, null)
}

output "dynamodb_gsi_autoscaling_read_policy_arns" {
  description = "ARNs of autoscaling read policies for GSI"
  value       = { for k, v in aws_appautoscaling_policy.gsi_read : k => v.arn }
}

output "dynamodb_gsi_autoscaling_write_policy_arns" {
  description = "ARNs of autoscaling write policies for GSI"
  value       = { for k, v in aws_appautoscaling_policy.gsi_write : k => v.arn }
}
