/*
  Variables: VPC & Subnet CIDR Configuration
  ------------------------------------------
  vpc_cidr_block:
    Defines the primary CIDR range for the VPC. This block determines the
    overall IP addressing boundary for all subnets and network resources
    created inside the VPC.

  subnet_newbits_cidr_block:
    Specifies how many additional bits to borrow from the VPC CIDR to
    calculate subnet CIDRs. For example, borrowing 8 bits from a /16 VPC
    produces /24 subnets. This value controls subnet size and the number
    of subnets that can be derived from the VPC range.
*/

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_newbits_cidr_block" {
  description = "The number of new bits to add to the VPC CIDR block for subnets (e.g., 8 for /24 subnets)"
  type        = number
  default     = 8
}



