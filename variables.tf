#################################################################################
# Table Configuration
#################################################################################

variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.table_name)) && length(var.table_name) >= 3 && length(var.table_name) <= 255
    error_message = "Table name must be 3-255 characters long and can only contain letters, numbers, underscores, hyphens, and periods."
  }
}

variable "billing_mode" {
  description = "Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY_PER_REQUEST"
  type        = string
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = contains(["PROVISIONED", "PAY_PER_REQUEST"], var.billing_mode)
    error_message = "billing_mode must be either PROVISIONED or PAY_PER_REQUEST."
  }
}

variable "table_class" {
  description = "Storage class of the table. Valid values are STANDARD and STANDARD_INFREQUENT_ACCESS"
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "STANDARD_INFREQUENT_ACCESS"], var.table_class)
    error_message = "table_class must be either STANDARD or STANDARD_INFREQUENT_ACCESS."
  }
}

variable "deletion_protection_enabled" {
  description = "Enables deletion protection for table"
  type        = bool
  default     = false
}

#################################################################################
# Hash & Range Key Configuration
#################################################################################

variable "hash_key" {
  description = "The attribute to use as the hash (partition) key. Must also be defined as an attribute"
  type        = string
}

variable "range_key" {
  description = "The attribute to use as the range (sort) key. Must also be defined as an attribute"
  type        = string
  default     = null
}

variable "attributes" {
  description = "List of nested attribute definitions. Only required for hash_key, range_key and indexes"
  type = list(object({
    name = string
    type = string
  }))

  validation {
    condition = alltrue([
      for attr in var.attributes : contains(["S", "N", "B"], attr.type)
    ])
    error_message = "Attribute type must be one of: S (string), N (number), B (binary)."
  }
}

#################################################################################
# Capacity Configuration
#################################################################################

variable "read_capacity" {
  description = "The number of read units for this table. If the billing_mode is PROVISIONED, this field is required"
  type        = number
  default     = null

  validation {
    condition     = var.read_capacity == null || var.read_capacity >= 1
    error_message = "read_capacity must be at least 1 when specified."
  }
}

variable "write_capacity" {
  description = "The number of write units for this table. If the billing_mode is PROVISIONED, this field is required"
  type        = number
  default     = null

  validation {
    condition     = var.write_capacity == null || var.write_capacity >= 1
    error_message = "write_capacity must be at least 1 when specified."
  }
}

variable "autoscaling_enabled" {
  description = "Whether to enable autoscaling for DynamoDB table"
  type        = bool
  default     = false
}

variable "autoscaling_read" {
  description = "A map of read autoscaling settings"
  type = object({
    scale_in_cooldown  = optional(number, 60)
    scale_out_cooldown = optional(number, 60)
    target_value       = optional(number, 70)
    max_capacity       = number
    min_capacity       = optional(number, 1)
  })
  default = null

  validation {
    condition = var.autoscaling_read == null || (
      var.autoscaling_read.max_capacity >= var.autoscaling_read.min_capacity &&
      var.autoscaling_read.min_capacity >= 1 &&
      var.autoscaling_read.target_value > 0 && var.autoscaling_read.target_value <= 100
    )
    error_message = "max_capacity must be >= min_capacity, min_capacity must be >= 1, and target_value must be between 1-100."
  }
}

variable "autoscaling_write" {
  description = "A map of write autoscaling settings"
  type = object({
    scale_in_cooldown  = optional(number, 60)
    scale_out_cooldown = optional(number, 60)
    target_value       = optional(number, 70)
    max_capacity       = number
    min_capacity       = optional(number, 1)
  })
  default = null

  validation {
    condition = var.autoscaling_write == null || (
      var.autoscaling_write.max_capacity >= var.autoscaling_write.min_capacity &&
      var.autoscaling_write.min_capacity >= 1 &&
      var.autoscaling_write.target_value > 0 && var.autoscaling_write.target_value <= 100
    )
    error_message = "max_capacity must be >= min_capacity, min_capacity must be >= 1, and target_value must be between 1-100."
  }
}

#################################################################################
# Global Secondary Index Configuration
#################################################################################

variable "global_secondary_indexes" {
  description = "Describe a GSI for the table"
  type = list(object({
    name               = string
    hash_key           = string
    range_key          = optional(string)
    write_capacity     = optional(number)
    read_capacity      = optional(number)
    projection_type    = optional(string, "ALL")
    non_key_attributes = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for gsi in var.global_secondary_indexes :
      contains(["ALL", "INCLUDE", "KEYS_ONLY"], gsi.projection_type)
    ])
    error_message = "GSI projection_type must be one of: ALL, INCLUDE, KEYS_ONLY."
  }
}

variable "gsi_autoscaling_read" {
  description = "A map of read autoscaling settings for GSI"
  type = map(object({
    scale_in_cooldown  = optional(number, 60)
    scale_out_cooldown = optional(number, 60)
    target_value       = optional(number, 70)
    max_capacity       = number
    min_capacity       = optional(number, 1)
  }))
  default = {}
}

variable "gsi_autoscaling_write" {
  description = "A map of write autoscaling settings for GSI"
  type = map(object({
    scale_in_cooldown  = optional(number, 60)
    scale_out_cooldown = optional(number, 60)
    target_value       = optional(number, 70)
    max_capacity       = number
    min_capacity       = optional(number, 1)
  }))
  default = {}
}

#################################################################################
# Local Secondary Index Configuration
#################################################################################

variable "local_secondary_indexes" {
  description = "Describe a LSI on the table"
  type = list(object({
    name               = string
    range_key          = string
    projection_type    = optional(string, "ALL")
    non_key_attributes = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for lsi in var.local_secondary_indexes :
      contains(["ALL", "INCLUDE", "KEYS_ONLY"], lsi.projection_type)
    ])
    error_message = "LSI projection_type must be one of: ALL, INCLUDE, KEYS_ONLY."
  }
}

#################################################################################
# Time to Live Configuration
#################################################################################

variable "ttl_enabled" {
  description = "Indicates whether ttl is enabled"
  type        = bool
  default     = false
}

variable "ttl_attribute_name" {
  description = "The name of the table attribute to store the TTL timestamp in"
  type        = string
  default     = "ttl"
}

#################################################################################
# Stream Configuration
#################################################################################

variable "stream_enabled" {
  description = "Indicates whether Streams are to be enabled (true) or disabled (false)"
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "When an item in the table is modified, StreamViewType determines what information is written to the table's stream"
  type        = string
  default     = "NEW_AND_OLD_IMAGES"

  validation {
    condition = contains([
      "KEYS_ONLY",
      "NEW_IMAGE",
      "OLD_IMAGE",
      "NEW_AND_OLD_IMAGES"
    ], var.stream_view_type)
    error_message = "stream_view_type must be one of: KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES."
  }
}

#################################################################################
# Encryption Configuration with SourceFuse Arc KMS Integration
#################################################################################

variable "server_side_encryption_enabled" {
  description = "Whether to enable server-side encryption"
  type        = bool
  default     = true
}

variable "server_side_encryption_kms_key_arn" {
  description = "The ARN of the CMK that should be used for the AWS KMS encryption. This attribute should only be specified if the key is different from the default DynamoDB CMK, alias/aws/dynamodb."
  type        = string
  default     = null
}

#################################################################################
# Backup and Recovery Configuration
#################################################################################

variable "point_in_time_recovery_enabled" {
  description = "Whether to enable point-in-time recovery"
  type        = bool
  default     = true
}

#################################################################################
# Contributor Insights Configuration
#################################################################################

variable "table_contributor_insights_enabled" {
  description = "Whether to enable contributor insights on table"
  type        = bool
  default     = false
}

variable "gsi_contributor_insights_enabled" {
  description = "Whether to enable contributor insights on GSI"
  type        = map(bool)
  default     = {}
}

#################################################################################
# Replica Configuration (Global Tables)
#################################################################################

variable "replica_regions" {
  description = "List of regions to create replicas in for Global Tables V2"
  type = list(object({
    region_name                    = string
    kms_key_arn                    = optional(string)
    propagate_tags                 = optional(bool, true)
    point_in_time_recovery_enabled = optional(bool, true)
    table_class                    = optional(string)
  }))
  default = []
}

#################################################################################
# Import Configuration
#################################################################################

variable "import_table" {
  description = "Configuration for importing data into the table"
  type = object({
    s3_bucket_source = object({
      bucket       = string
      bucket_owner = optional(string)
      key_prefix   = optional(string)
    })
    input_format = string
    input_format_options = optional(object({
      csv = optional(object({
        delimiter   = optional(string, ",")
        header_list = optional(list(string))
      }))
    }))
    input_compression_type = optional(string, "NONE")
  })
  default = null

  validation {
    condition     = var.import_table == null ? true : contains(["DYNAMODB_JSON", "ION", "CSV"], var.import_table.input_format)
    error_message = "input_format must be one of: DYNAMODB_JSON, ION, CSV."
  }

  validation {
    condition     = var.import_table == null ? true : contains(["GZIP", "ZSTD", "NONE"], var.import_table.input_compression_type)
    error_message = "input_compression_type must be one of: GZIP, ZSTD, NONE."
  }
}

#################################################################################
# SourceFuse Arc Tags Module Integration
#################################################################################

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
