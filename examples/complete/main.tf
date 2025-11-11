################################################################################
# Complete Example - DynamoDB table with all features
################################################################################

provider "aws" {
  region = var.region
}

module "dynamodb_table" {
  source = "../../"

  # Basic Configuration
  table_name   = var.table_name
  billing_mode = "PROVISIONED"
  hash_key     = "userId"
  range_key    = "timestamp"

  # Attributes
  attributes = [
    {
      name = "userId"
      type = "S"
    },
    {
      name = "timestamp"
      type = "N"
    },
    {
      name = "gameTitle"
      type = "S"
    },
    {
      name = "topScore"
      type = "N"
    },
    {
      name = "status"
      type = "S"
    }
  ]

  # Provisioned Capacity
  read_capacity  = 20
  write_capacity = 20

  # Autoscaling
  autoscaling_enabled = true
  autoscaling_read = {
    scale_in_cooldown  = 50
    scale_out_cooldown = 40
    target_value       = 45
    max_capacity       = 100
    min_capacity       = 5
  }
  autoscaling_write = {
    scale_in_cooldown  = 50
    scale_out_cooldown = 40
    target_value       = 45
    max_capacity       = 100
    min_capacity       = 5
  }

  # Global Secondary Indexes
  global_secondary_indexes = [
    {
      name               = "GameTitleIndex"
      hash_key           = "gameTitle"
      range_key          = "topScore"
      write_capacity     = 10
      read_capacity      = 10
      projection_type    = "INCLUDE"
      non_key_attributes = ["userId"]
    },
    {
      name            = "StatusIndex"
      hash_key        = "status"
      projection_type = "KEYS_ONLY"
      write_capacity  = 5
      read_capacity   = 5
    }
  ]

  # GSI Autoscaling
  gsi_autoscaling_read = {
    GameTitleIndex = {
      max_capacity = 50
      min_capacity = 5
      target_value = 70
    }
    StatusIndex = {
      max_capacity = 25
      min_capacity = 5
      target_value = 70
    }
  }

  gsi_autoscaling_write = {
    GameTitleIndex = {
      max_capacity = 50
      min_capacity = 5
      target_value = 70
    }
    StatusIndex = {
      max_capacity = 25
      min_capacity = 5
      target_value = 70
    }
  }

  # Local Secondary Index
  local_secondary_indexes = [
    {
      name            = "UserTimestampIndex"
      range_key       = "topScore"
      projection_type = "ALL"
    }
  ]

  # Stream Configuration
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  # TTL Configuration
  ttl_enabled        = true
  ttl_attribute_name = "expires"

  # Encryption
  server_side_encryption_enabled    = true
  server_side_encryption_kms_key_id = var.kms_key_id

  # Point-in-time Recovery
  point_in_time_recovery_enabled = true

  # Contributor Insights
  table_contributor_insights_enabled = true
  gsi_contributor_insights_enabled = {
    GameTitleIndex = true
    StatusIndex    = true
  }

  # Global Tables (Multi-region) - Removed for compatibility with provisioned + autoscaling
  # replica_regions = [
  #   {
  #     region_name = "us-west-2"
  #   },
  #   {
  #     region_name = "eu-west-1"
  #   }
  # ]

  # Deletion Protection
  deletion_protection_enabled = true

  # Tags
  tags = var.tags
}
