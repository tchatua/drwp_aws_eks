/*
    Data Source: aws_region
        aws_region provides details about a specific AWS Region.
        
    As well as validating a given Region name this resource can be used to discover the name 
    of the Region configured within the provider. The latter can be useful in a child module 
    which is inheriting an AWS provider configuration from its parent module.
*/

data "aws_region" "current" {}