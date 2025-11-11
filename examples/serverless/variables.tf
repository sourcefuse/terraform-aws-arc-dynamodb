variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "serverless-example-table"
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "example"
    BillingMode = "serverless"
    Module      = "terraform-aws-arc-dynamodb"
  }
}
