################################################################################
# Basic Example - Simple DynamoDB table
################################################################################

provider "aws" {
  region = var.region
}

module "dynamodb_table" {
  source = "../../"

  # Basic Configuration
  table_name   = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  # Attributes
  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]

  # Basic Encryption
  server_side_encryption_enabled = true

  # Point-in-time Recovery
  point_in_time_recovery_enabled = false

  # Tags
  tags = var.tags
}
