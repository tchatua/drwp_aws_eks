/*
  Data Source: aws_availability_zone.available_zone
  -------------------------------------------------
  Retrieves a single Availability Zone in the region configured
  on the AWS provider. Only AZs in the "available" state are
  considered valid. This is typically used when network resources
  (subnets, route tables, gateways, etc.) must be created within
  a specific, healthy AZ of the selected region.
*/
data "aws_availability_zones" "available_zone" {
  state = "available"
}


