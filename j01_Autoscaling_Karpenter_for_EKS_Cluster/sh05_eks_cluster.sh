aws ec2 describe-subnets \
  --filters "Name=tag:kubernetes.io/role/internal-elb,Values=1" \
  --region us-east-2
{
    "Subnets": [
        {
            "AvailabilityZoneId": "use2-az2",
            "MapCustomerOwnedIpOnLaunch": false,
            "OwnerId": "088354478627",
            "AssignIpv6AddressOnCreation": false,
            "Ipv6CidrBlockAssociationSet": [],
            "Tags": [
                {
                    "Key": "Demo",
                    "Value": "VPC with Remote Backend Demonstration - V101"
                },
                {
                    "Key": "Owner",
                    "Value": "Arristide Tchatua"
                },
                {
                    "Key": "kubernetes.io/cluster/south-jersey-eks-tchatua-dev-drwpekscluster",
                    "Value": "owned"
                },
                {
                    "Key": "Email",
                    "Value": "tchattua@gmail.com"
                },
                {
                    "Key": "Name",
                    "Value": "qa-drwp-private-subnet-us-east-2b"
                },
                {
                    "Key": "Project",
                    "Value": "drwp-eks"
                },
                {
                    "Key": "Terraform",
                    "Value": "true"
                },
                {
                    "Key": "kubernetes.io/role/internal-elb",
                    "Value": "1"
                }
            ],
            "SubnetArn": "arn:aws:ec2:us-east-2:088354478627:subnet/subnet-0a045721ae0be0436",
            "EnableDns64": false,
            "Ipv6Native": false,
            "PrivateDnsNameOptionsOnLaunch": {
                "HostnameType": "ip-name",
                "EnableResourceNameDnsARecord": false,
                "EnableResourceNameDnsAAAARecord": false
            },
            "BlockPublicAccessStates": {
                "InternetGatewayBlockMode": "off"
            },
            "SubnetId": "subnet-0a045721ae0be0436",
            "State": "available",
            "VpcId": "vpc-0e470907c96317802",
            "CidrBlock": "192.168.11.0/24",
            "AvailableIpAddressCount": 238,
            "AvailabilityZone": "us-east-2b",
            "DefaultForAz": false,
            "MapPublicIpOnLaunch": false
        },
        {
            "AvailabilityZoneId": "use2-az3",
            "MapCustomerOwnedIpOnLaunch": false,
            "OwnerId": "088354478627",
            "AssignIpv6AddressOnCreation": false,
            "Ipv6CidrBlockAssociationSet": [],
            "Tags": [
                {
                    "Key": "Owner",
                    "Value": "Arristide Tchatua"
                },
                {
                    "Key": "kubernetes.io/cluster/south-jersey-eks-tchatua-dev-drwpekscluster",
                    "Value": "owned"
                },
                {
                    "Key": "kubernetes.io/role/internal-elb",
                    "Value": "1"
                },
                {
                    "Key": "Name",
                    "Value": "qa-drwp-private-subnet-us-east-2c"
                },
                {
                    "Key": "Project",
                    "Value": "drwp-eks"
                },
                {
                    "Key": "Terraform",
                    "Value": "true"
                },
                {
                    "Key": "Email",
                    "Value": "tchattua@gmail.com"
                },
                {
                    "Key": "Demo",
                    "Value": "VPC with Remote Backend Demonstration - V101"
                }
            ],
            "SubnetArn": "arn:aws:ec2:us-east-2:088354478627:subnet/subnet-037489b0725fabe93",
            "EnableDns64": false,
            "Ipv6Native": false,
            "PrivateDnsNameOptionsOnLaunch": {
                "HostnameType": "ip-name",
                "EnableResourceNameDnsARecord": false,
                "EnableResourceNameDnsAAAARecord": false
            },
            "BlockPublicAccessStates": {
                "InternetGatewayBlockMode": "off"
            },
            "SubnetId": "subnet-037489b0725fabe93",
            "State": "available",
            "VpcId": "vpc-0e470907c96317802",
            "CidrBlock": "192.168.12.0/24",
            "AvailableIpAddressCount": 243,
            "AvailabilityZone": "us-east-2c",
            "DefaultForAz": false,
            "MapPublicIpOnLaunch": false
        },
        {
            "AvailabilityZoneId": "use2-az1",
            "MapCustomerOwnedIpOnLaunch": false,
            "OwnerId": "088354478627",
            "AssignIpv6AddressOnCreation": false,
            "Ipv6CidrBlockAssociationSet": [],
            "Tags": [
                {
                    "Key": "Terraform",
                    "Value": "true"
                },
                {
                    "Key": "Name",
                    "Value": "qa-drwp-private-subnet-us-east-2a"
                },
                {
                    "Key": "kubernetes.io/role/internal-elb",
                    "Value": "1"
                },
                {
                    "Key": "Project",
                    "Value": "drwp-eks"
                },
                {
                    "Key": "Email",
                    "Value": "tchattua@gmail.com"
                },
                {
                    "Key": "kubernetes.io/cluster/south-jersey-eks-tchatua-dev-drwpekscluster",
                    "Value": "owned"
                },
                {
                    "Key": "Demo",
                    "Value": "VPC with Remote Backend Demonstration - V101"
                },
                {
                    "Key": "Owner",
                    "Value": "Arristide Tchatua"
                }
            ],
            "SubnetArn": "arn:aws:ec2:us-east-2:088354478627:subnet/subnet-0739442a734c80426",
            "EnableDns64": false,
            "Ipv6Native": false,
            "PrivateDnsNameOptionsOnLaunch": {
                "HostnameType": "ip-name",
                "EnableResourceNameDnsARecord": false,
                "EnableResourceNameDnsAAAARecord": false
            },
            "BlockPublicAccessStates": {
                "InternetGatewayBlockMode": "off"
            },
            "SubnetId": "subnet-0739442a734c80426",
            "State": "available",
            "VpcId": "vpc-0e470907c96317802",
            "CidrBlock": "192.168.10.0/24",
            "AvailableIpAddressCount": 242,
            "AvailabilityZone": "us-east-2a",
            "DefaultForAz": false,
            "MapPublicIpOnLaunch": false
        }
    ]
}
