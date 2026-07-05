/*
  Resource: aws_vpc.main
  -----------------------
  Defines the primary Virtual Private Cloud (VPC) for the environment.
  This establishes the core networking boundary and provides the CIDR
  range from which all subnets and routing components are derived.
  DNS support and hostnames are enabled to allow internal name
  resolution and automatic hostname assignment for EC2 instances.

  The lifecycle configuration ensures safe updates:
    - create_before_destroy:
        Allows Terraform to provision a replacement VPC before removing
        the existing one, reducing the risk of downtime during changes
        that require recreation.
    - prevent_destroy (optional):
        When enabled, protects the VPC from accidental deletion. This is
        typically used in production environments where destroying the
        VPC would cause widespread service disruption.
*/
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, {
    Name = "${var.environment_name}-${var.project_name}-vpc"
  })

  lifecycle {
    create_before_destroy = true
    # prevent_destroy       = true
  }
}

/*
  Resource: aws_internet_gateway.igw
  ----------------------------------
  Provisions an Internet Gateway (IGW) and attaches it to the primary VPC.
  The IGW enables outbound and inbound connectivity between resources in
  public subnets and the public internet. This is required for EC2 instances
  that need direct internet access (e.g., package installation, public-facing applications). 
  Tags include environment and project identifiers for clear resource tracking and lifecycle management.
*/
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, {
    Name = "${var.environment_name}-${var.project_name}-igw"
  })
}

/*
  Resource: aws_subnet.public
  ---------------------------
  Creates one public subnet per Availability Zone using a for_each
  expression that maps each AZ to its corresponding CIDR block.
  These subnets are configured to assign public IPs on instance
  launch, making them suitable for internet-facing workloads.

  The lifecycle rule `create_before_destroy` ensures zero-downtime
  updates when subnet definitions change. Tags include environment
  and project identifiers, along with the AZ name for clear
  identification across multi-AZ deployments.

  The optional `prevent_destroy` safeguard can be enabled to protect
  critical networking components from accidental deletion. When set
  to true, Terraform will refuse to destroy the subnet—even during
  updates that require recreation—forcing an explicit override to
  avoid unintended outages.
*/
resource "aws_subnet" "public" {
  for_each                = { for idx, az in local.azs : az => local.public_subnet_cidrs[idx] }
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags = merge(var.tags, {
    Name = "${var.environment_name}-${var.project_name}-public-subnet-${each.key}"
  })

  lifecycle {
    create_before_destroy = true
    # prevent_destroy       = true
  }
}

/*
Resource: aws_subnet.private
  ----------------------------
  Creates one private subnet per Availability Zone using a for_each
  expression that maps each AZ to its corresponding CIDR block.
  These subnets do not assign public IPs and are intended for
  internal workloads such as application servers, databases, and
  services that should not be directly exposed to the internet.

  The lifecycle rule `create_before_destroy` ensures safe updates
  when subnet definitions change by allowing Terraform to provision
  replacement subnets before removing existing ones. The optional
  `prevent_destroy` safeguard can be enabled to protect critical
  private subnets from accidental deletion in production environments.

  Tags include environment and project identifiers, along with the
  AZ name, to maintain clear visibility across multi-AZ deployments.
*/
resource "aws_subnet" "private" {
  for_each          = { for idx, az in local.azs : az => local.private_subnet_cidrs[idx] }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key
  tags = merge(var.tags, {
    Name = "${var.environment_name}-${var.project_name}-private-subnet-${each.key}"
  })

  lifecycle {
    create_before_destroy = true
    # prevent_destroy       = true
  }
}

resource "aws_eip" "nat_eip" {
  tags = merge(var.tags, {
    Name = "${var.environment_name}-${var.project_name}-nat-eip"
  })
  depends_on = [aws_internet_gateway.igw]
}

/*
  Resource: aws_nat_gateway.nat_gw
  --------------------------------
  Provisions a managed NAT Gateway to enable outbound internet access
  for private subnets while keeping their resources unreachable from
  the public internet. The NAT Gateway is placed in the first public
  subnet and uses an Elastic IP for stable, routable connectivity.

  An explicit dependency on the Internet Gateway ensures correct
  provisioning order, preventing race conditions where the NAT
  Gateway could be created before the VPC has external connectivity.
  Tags include environment and project identifiers for consistent
  tracking across environments.
*/
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = values(aws_subnet.public)[0].id

  tags = merge(var.tags, {
    Name = "${var.environment_name}-${var.project_name}-nat-gw"
  })
  depends_on = [aws_internet_gateway.igw]
}


/*
  Resource: aws_route_table.public_rt
  -----------------------------------
  Creates the public route table for the VPC. This route table includes
  a default route (0.0.0.0/0) that directs all outbound traffic to the
  Internet Gateway, enabling internet connectivity for resources placed
  in public subnets.

  Tags include environment and project identifiers for clear visibility
  and lifecycle tracking across environments.
*/
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, {
    Name = "${var.environment_name}-${var.project_name}-public-rt"
  })
}

/*
  Resource: aws_route_table_association.public_rt_assoc
  -----------------------------------------------------
  Associates each public subnet with the public route table. This ensures
  that all subnets designated as public inherit the default route to the
  Internet Gateway, enabling outbound internet access for EC2 instances
  and other public-facing resources.

  The for_each expression automatically links every public subnet to the
  route table, maintaining consistency across multi-AZ deployments.
*/
resource "aws_route_table_association" "public_rt_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

/*
  Resource: aws_route_table.private_rt
  ------------------------------------
  Creates the private route table for the VPC. This route table defines
  a default route (0.0.0.0/0) that sends outbound traffic from private
  subnets to the NAT Gateway. This allows instances in private subnets
  to access the internet for updates, package downloads, and external
  API calls while remaining unreachable from the public internet.

  Tags include environment and project identifiers to maintain clear
  visibility and lifecycle tracking across environments.
*/
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = merge(var.tags, {
    Name = "${var.environment_name}-${var.project_name}-private-rt"
  })
}

/*
  Resource: aws_route_table_association.private_rt_assoc
  ------------------------------------------------------
  Associates each private subnet with the private route table. This ensures
  that all private subnets inherit the default route to the NAT Gateway,
  enabling secure outbound-only internet access for internal workloads.

  The for_each expression automatically links every private subnet to the
  route table, ensuring consistent routing behavior across all AZs in the
  deployment.
*/
resource "aws_route_table_association" "private_rt_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}
