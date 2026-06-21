/*
    ---------------------------------------------------------------
    DynamoDB Table: Items (Region: us-west-2)
    ---------------------------------------------------------------

    CONTEXT:
    The Cart microservice from the AWS Store Sample App is hardcoded
    to use the DynamoDB endpoint in the "us-west-2" region.

    Source Code:
      File: DynamoDBConfiguration.java
      GitHub: https://github.com/aws-containers/retail-store-sample-app/blob/v1.3.0/src/cart/src/main/java/com/amazon/sample/carts/config/DynamoDBConfiguration.java
      Line: builder.region(Region.US_WEST_2);

    Because the application explicitly sets Region.US_WEST_2, the DynamoDB
    table must be created in that region to avoid runtime failures.

    IMPLEMENTATION:
    We use an aliased AWS provider (aws.west2) to ensure the table is created
    in the correct region without modifying application code.

    NOTES:
    - PAY_PER_REQUEST is ideal for unpredictable workloads.
    - GSI on customerId enables efficient customer‑centric queries.
    - Table name "Items" is required by the sample application.
*/
# DynamoDB Table: Items - us-west-2
resource "aws_dynamodb_table" "items_west2" {
  provider     = aws.west2
  name         = "Items"
  billing_mode = "PAY_PER_REQUEST" # On-demand pricing (no capacity planning)
  hash_key     = "id"

  # Primary key  
  attribute {
    name = "id"
    type = "S"
  }

  # Attribute used by the GSI
  attribute {
    name = "customerId"
    type = "S"
  }

  # Global Secondary Index for customer-based lookups
  global_secondary_index {
    name            = "idx_global_customerId"
    hash_key        = "customerId"
    projection_type = "ALL"
  }

  tags = merge(var.tags, {
    Name        = "Items"
    Environment = var.environment_name
    Component   = "Cart"
  })

}

