#################################################################################
# DynamoDB Table
#################################################################################

resource "aws_dynamodb_table" "this" {
  count = var.create_table ? 1 : 0

  name             = var.table_name
  billing_mode     = var.billing_mode
  hash_key         = var.hash_key
  range_key        = var.range_key
  read_capacity    = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity   = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_enabled ? var.stream_view_type : null
  table_class      = var.table_class

  deletion_protection_enabled = var.deletion_protection_enabled

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      hash_key           = global_secondary_index.value.hash_key
      name               = global_secondary_index.value.name
      non_key_attributes = global_secondary_index.value.projection_type == "INCLUDE" ? global_secondary_index.value.non_key_attributes : null
      projection_type    = global_secondary_index.value.projection_type
      range_key          = global_secondary_index.value.range_key
      read_capacity      = var.billing_mode == "PROVISIONED" ? global_secondary_index.value.read_capacity : null
      write_capacity     = var.billing_mode == "PROVISIONED" ? global_secondary_index.value.write_capacity : null
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes
    content {
      name               = local_secondary_index.value.name
      non_key_attributes = local_secondary_index.value.projection_type == "INCLUDE" ? local_secondary_index.value.non_key_attributes : null
      projection_type    = local_secondary_index.value.projection_type
      range_key          = local_secondary_index.value.range_key
    }
  }

  dynamic "ttl" {
    for_each = var.ttl_enabled ? [1] : []
    content {
      attribute_name = var.ttl_attribute_name
      enabled        = var.ttl_enabled
    }
  }

  dynamic "server_side_encryption" {
    for_each = var.server_side_encryption_enabled ? [1] : []
    content {
      enabled     = true
      kms_key_arn = var.server_side_encryption_kms_key_id
    }
  }

  dynamic "point_in_time_recovery" {
    for_each = [1]
    content {
      enabled = var.point_in_time_recovery_enabled
    }
  }

  dynamic "replica" {
    for_each = var.replica_regions
    content {
      region_name = replica.value.region_name
    }
  }

  dynamic "import_table" {
    for_each = var.import_table != null ? [var.import_table] : []
    content {
      input_format           = import_table.value.input_format
      input_compression_type = import_table.value.input_compression_type

      s3_bucket_source {
        bucket       = import_table.value.s3_bucket_source.bucket
        bucket_owner = import_table.value.s3_bucket_source.bucket_owner
        key_prefix   = import_table.value.s3_bucket_source.key_prefix
      }

      dynamic "input_format_options" {
        for_each = import_table.value.input_format_options != null ? [import_table.value.input_format_options] : []
        content {
          dynamic "csv" {
            for_each = input_format_options.value.csv != null ? [input_format_options.value.csv] : []
            content {
              delimiter   = csv.value.delimiter
              header_list = csv.value.header_list
            }
          }
        }
      }
    }
  }

  tags = var.tags
}

#################################################################################
# DynamoDB Table Contributor Insights
#################################################################################

resource "aws_dynamodb_contributor_insights" "table" {
  count      = var.create_table && var.table_contributor_insights_enabled ? 1 : 0
  table_name = aws_dynamodb_table.this[0].name
}

resource "aws_dynamodb_contributor_insights" "gsi" {
  for_each   = var.create_table ? var.gsi_contributor_insights_enabled : {}
  table_name = aws_dynamodb_table.this[0].name
  index_name = each.key
}

#################################################################################
# DynamoDB Autoscaling - Table
#################################################################################

resource "aws_appautoscaling_target" "table_read" {
  count              = var.create_table && var.autoscaling_enabled && var.autoscaling_read != null && var.billing_mode == "PROVISIONED" ? 1 : 0
  max_capacity       = var.autoscaling_read.max_capacity
  min_capacity       = var.autoscaling_read.min_capacity
  resource_id        = "table/${aws_dynamodb_table.this[0].name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "table_read" {
  count              = var.create_table && var.autoscaling_enabled && var.autoscaling_read != null && var.billing_mode == "PROVISIONED" ? 1 : 0
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.table_read[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.table_read[0].resource_id
  scalable_dimension = aws_appautoscaling_target.table_read[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.table_read[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value       = var.autoscaling_read.target_value
    scale_in_cooldown  = var.autoscaling_read.scale_in_cooldown
    scale_out_cooldown = var.autoscaling_read.scale_out_cooldown
  }
}

resource "aws_appautoscaling_target" "table_write" {
  count              = var.create_table && var.autoscaling_enabled && var.autoscaling_write != null && var.billing_mode == "PROVISIONED" ? 1 : 0
  max_capacity       = var.autoscaling_write.max_capacity
  min_capacity       = var.autoscaling_write.min_capacity
  resource_id        = "table/${aws_dynamodb_table.this[0].name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "table_write" {
  count              = var.create_table && var.autoscaling_enabled && var.autoscaling_write != null && var.billing_mode == "PROVISIONED" ? 1 : 0
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.table_write[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.table_write[0].resource_id
  scalable_dimension = aws_appautoscaling_target.table_write[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.table_write[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value       = var.autoscaling_write.target_value
    scale_in_cooldown  = var.autoscaling_write.scale_in_cooldown
    scale_out_cooldown = var.autoscaling_write.scale_out_cooldown
  }
}

#################################################################################
# DynamoDB Autoscaling - Global Secondary Indexes
#################################################################################

resource "aws_appautoscaling_target" "gsi_read" {
  for_each           = var.create_table && var.autoscaling_enabled && var.billing_mode == "PROVISIONED" ? var.gsi_autoscaling_read : {}
  max_capacity       = each.value.max_capacity
  min_capacity       = each.value.min_capacity
  resource_id        = "table/${aws_dynamodb_table.this[0].name}/index/${each.key}"
  scalable_dimension = "dynamodb:index:ReadCapacityUnits"
  service_namespace  = "dynamodb"

  depends_on = [aws_dynamodb_table.this]
}

resource "aws_appautoscaling_policy" "gsi_read" {
  for_each           = var.create_table && var.autoscaling_enabled && var.billing_mode == "PROVISIONED" ? var.gsi_autoscaling_read : {}
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.gsi_read[each.key].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.gsi_read[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.gsi_read[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.gsi_read[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value       = each.value.target_value
    scale_in_cooldown  = each.value.scale_in_cooldown
    scale_out_cooldown = each.value.scale_out_cooldown
  }
}

resource "aws_appautoscaling_target" "gsi_write" {
  for_each           = var.create_table && var.autoscaling_enabled && var.billing_mode == "PROVISIONED" ? var.gsi_autoscaling_write : {}
  max_capacity       = each.value.max_capacity
  min_capacity       = each.value.min_capacity
  resource_id        = "table/${aws_dynamodb_table.this[0].name}/index/${each.key}"
  scalable_dimension = "dynamodb:index:WriteCapacityUnits"
  service_namespace  = "dynamodb"

  depends_on = [aws_dynamodb_table.this]
}

resource "aws_appautoscaling_policy" "gsi_write" {
  for_each           = var.create_table && var.autoscaling_enabled && var.billing_mode == "PROVISIONED" ? var.gsi_autoscaling_write : {}
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.gsi_write[each.key].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.gsi_write[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.gsi_write[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.gsi_write[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value       = each.value.target_value
    scale_in_cooldown  = each.value.scale_in_cooldown
    scale_out_cooldown = each.value.scale_out_cooldown
  }
}
