################################################################################
# Serverless Example - DynamoDB table with pay-per-request billing
################################################################################

provider "aws" {
  region = var.region
}

module "dynamodb_table" {
  source = "../../"

  # Basic Configuration
  table_name   = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"
  range_key    = "sk"

  # Attributes
  attributes = [
    {
      name = "pk"
      type = "S"
    },
    {
      name = "sk"
      type = "S"
    },
    {
      name = "gsi1pk"
      type = "S"
    },
    {
      name = "gsi1sk"
      type = "S"
    }
  ]

  # Global Secondary Indexes (no capacity needed for PAY_PER_REQUEST)
  global_secondary_indexes = [
    {
      name            = "GSI1"
      hash_key        = "gsi1pk"
      range_key       = "gsi1sk"
      projection_type = "ALL"
    }
  ]

  # Stream Configuration
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  # TTL Configuration
  ttl_enabled        = true
  ttl_attribute_name = "expires_at"

  # Encryption (using AWS managed key)
  server_side_encryption_enabled = true

  # Point-in-time Recovery
  point_in_time_recovery_enabled = true

  # Table Class (Standard-IA for infrequent access)
  table_class = "STANDARD_INFREQUENT_ACCESS"

  # Global Tables (Multi-region replication) - Works with PAY_PER_REQUEST
  replica_regions = [
    {
      region_name = "us-east-2"
    }
  ]

  # Tags
  tags = var.tags
}
