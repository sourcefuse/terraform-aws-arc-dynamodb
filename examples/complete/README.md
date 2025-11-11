# Complete DynamoDB Table Example

This example demonstrates a comprehensive DynamoDB table configuration with all advanced features enabled using the terraform-aws-arc-dynamodb module.

## Features

- Provisioned billing mode with autoscaling
- Global and Local Secondary Indexes
- DynamoDB Streams
- Server-side encryption with KMS
- Point-in-time recovery
- TTL configuration
- CloudWatch Contributor Insights
- Deletion protection

**Note:** Global Tables are commented out due to AWS limitations with provisioned capacity and autoscaling. For Global Tables functionality, see the serverless example which uses PAY_PER_REQUEST billing mode.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

**Note:** This example creates provisioned capacity resources that may incur costs. Make sure to run `terraform destroy` when you don't need these resources.

## Architecture

This example creates:

- A DynamoDB table with provisioned capacity
- Auto-scaling policies for read and write capacity
- Global Secondary Indexes with their own autoscaling
- Local Secondary Index for alternative sort patterns
- DynamoDB Streams for real-time processing
- Comprehensive monitoring and insights

## Prerequisites

- AWS credentials configured
- KMS key (optional, will use AWS managed key if not provided)
- Appropriate IAM permissions for DynamoDB operations

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

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
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN of the CMK that should be used for the AWS KMS encryption | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | Name of the DynamoDB table | `string` | `"complete-example-table"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource | `map(string)` | <pre>{<br/>  "Environment": "example",<br/>  "Module": "terraform-aws-arc-dynamodb",<br/>  "Terraform": "true"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb_table_arn"></a> [dynamodb\_table\_arn](#output\_dynamodb\_table\_arn) | ARN of the DynamoDB table |
| <a name="output_dynamodb_table_global_secondary_index_names"></a> [dynamodb\_table\_global\_secondary\_index\_names](#output\_dynamodb\_table\_global\_secondary\_index\_names) | List of global secondary index names |
| <a name="output_dynamodb_table_id"></a> [dynamodb\_table\_id](#output\_dynamodb\_table\_id) | ID of the DynamoDB table |
| <a name="output_dynamodb_table_local_secondary_index_names"></a> [dynamodb\_table\_local\_secondary\_index\_names](#output\_dynamodb\_table\_local\_secondary\_index\_names) | List of local secondary index names |
| <a name="output_dynamodb_table_name"></a> [dynamodb\_table\_name](#output\_dynamodb\_table\_name) | Name of the DynamoDB table |
| <a name="output_dynamodb_table_stream_arn"></a> [dynamodb\_table\_stream\_arn](#output\_dynamodb\_table\_stream\_arn) | ARN of the DynamoDB table stream |
| <a name="output_dynamodb_table_stream_label"></a> [dynamodb\_table\_stream\_label](#output\_dynamodb\_table\_stream\_label) | Timestamp, in ISO 8601 format, for this stream |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
