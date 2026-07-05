

```sh
aws eks list-clusters
{
    "clusters": [
        "south-jersey-eks-tchatua-dev-eks-control-plane"
    ]
}

```

## Tag your PUBLIC subnets
```sh
aws ec2 create-tags \
  --resources subnet-0fa76b57e2951c0b9 \
  --tags Key=kubernetes.io/role/elb,Value=1 \
         Key=kubernetes.io/cluster/south-jersey-eks-tchatua-dev-eks-control-plane,Value=shared

aws ec2 create-tags \
  --resources subnet-0982219ddab19ffcd \
  --tags Key=kubernetes.io/role/elb,Value=1 \
         Key=kubernetes.io/cluster/south-jersey-eks-tchatua-dev-eks-control-plane,Value=shared
```

## Tag Private subnets

```sh
aws ec2 create-tags \
  --resources subnet-05977d3556896743e \
  --tags Key=kubernetes.io/role/internal-elb,Value=1 \
         Key=kubernetes.io/cluster/south-jersey-eks-tchatua-dev-eks-control-plane,Value=shared

aws ec2 create-tags \
  --resources subnet-0868c0588ae4b54bd \
  --tags Key=kubernetes.io/role/internal-elb,Value=1 \
         Key=kubernetes.io/cluster/south-jersey-eks-tchatua-dev-eks-control-plane,Value=shared
```

# Request a new certificate in us-east-2

> Go to AWS Console → ACM → Region: us-east-2

- Request a certificate:
- Type: Public certificate
- Domain: *.<your-domain> or your specific domain
- Validate via DNS
- Once it shows Issued, continue.

## Get the new certificate ARN

- In ACM (us-east-2), copy the ARN:
    - Example:
```tf
arn:aws:acm:us-east-2:180789647333:certificate/abcd1234-5678-...

```

## Update my Ingress

```yml
alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:us-east-2:180789647333:certificate/<NEW_CERT_ID>
```