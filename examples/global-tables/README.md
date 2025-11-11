# Serverless DynamoDB Table Example

This example demonstrates how to create a serverless DynamoDB table with global tables using the terraform-aws-arc-dynamodb module.

## Features

- Pay-per-request billing mode (serverless)
- Standard-IA table class for cost optimization
- DynamoDB Streams enabled
- Global Secondary Index
- TTL configuration
- Server-side encryption
- Global Tables

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

## Architecture

This example creates:

- A DynamoDB table with pay-per-request billing
- A Global Secondary Index for alternative query patterns
- DynamoDB Streams for real-time data processing
- TTL for automatic data expiration

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dynamodb_table"></a> [dynamodb\_table](#module\_dynamodb\_table) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | Name of the DynamoDB table | `string` | `"serverless-example-table"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource | `map(string)` | <pre>{<br/>  "BillingMode": "serverless",<br/>  "Environment": "example",<br/>  "Module": "terraform-aws-arc-dynamodb",<br/>  "Terraform": "true"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb_table_arn"></a> [dynamodb\_table\_arn](#output\_dynamodb\_table\_arn) | ARN of the DynamoDB table |
| <a name="output_dynamodb_table_billing_mode"></a> [dynamodb\_table\_billing\_mode](#output\_dynamodb\_table\_billing\_mode) | Billing mode of the DynamoDB table |
| <a name="output_dynamodb_table_name"></a> [dynamodb\_table\_name](#output\_dynamodb\_table\_name) | Name of the DynamoDB table |
| <a name="output_dynamodb_table_stream_arn"></a> [dynamodb\_table\_stream\_arn](#output\_dynamodb\_table\_stream\_arn) | ARN of the DynamoDB table stream |
| <a name="output_dynamodb_table_table_class"></a> [dynamodb\_table\_table\_class](#output\_dynamodb\_table\_table\_class) | Storage class of the DynamoDB table |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
