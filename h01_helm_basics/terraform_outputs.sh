Apply complete! Resources: 24 added, 0 changed, 0 destroyed.

Outputs:

cart_dynamodb_pod_identity_association_arn = "arn:aws:eks:us-east-2:088354478627:podidentityassociation/south-jersey-eks-tchatua-dev-eks-control-plane/a-kcucmfvfdrviiqqnk"
cart_dynamodb_policy_arn = "arn:aws:iam::088354478627:policy/south-jersey-eks-tchatua-dev-cart-dynamodb-policy"
cart_dynamodb_role_arn = "arn:aws:iam::088354478627:role/south-jersey-eks-tchatua-dev-cart-dynamodb-role"
catalog_rds_endpoint = "mydb3.c7oescqy4eh4.us-east-2.rds.amazonaws.com"
catalog_rds_sg_id = "sg-045484a269fe8402b"
catalog_sa_getsecrets_role_arn = "arn:aws:iam::088354478627:role/south-jersey-eks-tchatua-dev-catalog-getsecrets-role"
catalog_sa_pod_identity_association_arn = "arn:aws:eks:us-east-2:088354478627:podidentityassociation/south-jersey-eks-tchatua-dev-eks-control-plane/a-stwc2q0ti3acgtp90"
checkout_redis_endpoint = "south-jersey-eks-tchatua-dev-checkout-redis.sx505s.0001.use2.cache.amazonaws.com"
debug_app_store_secret_password = <sensitive>
debug_app_store_secret_username = <sensitive>
eks_cluster_id = "south-jersey-eks-tchatua-dev-eks-control-plane"
eks_cluster_name = "south-jersey-eks-tchatua-dev-eks-control-plane"
eks_cluster_security_group_id = "sg-007620d9910069d8e"
orders_postgresql_sa_getsecrets_role_arn = "arn:aws:iam::088354478627:role/south-jersey-eks-tchatua-dev-orders-postgresql-getsecrets-role"
orders_postgresql_sa_pod_identity_association_arn = "arn:aws:eks:us-east-2:088354478627:podidentityassociation/south-jersey-eks-tchatua-dev-eks-control-plane/a-mlcrqx7olqpgtjmfn"
orders_rds_postgresql_db_name = "ordersdb"
orders_rds_postgresql_endpoint = "orders-postgres-db.c7oescqy4eh4.us-east-2.rds.amazonaws.com:5432"
orders_sqs_policy_arn = "arn:aws:iam::088354478627:policy/south-jersey-eks-tchatua-dev-orders-sqs-policy"
orders_sqs_queue_arn = "arn:aws:sqs:us-east-2:088354478627:south-jersey-eks-tchatua-dev-orders-queue"
orders_sqs_queue_url = "https://sqs.us-east-2.amazonaws.com/088354478627/south-jersey-eks-tchatua-dev-orders-queue"
private_subnet_ids = [
  "subnet-015c6de8836e89de3",
  "subnet-032a9d12c6406762d",
  "subnet-0016aa2f068775e07",
]
public_subnet_ids = [
  "subnet-05ac67c17a984808e",
  "subnet-0ef6b2ff9669d117f",
  "subnet-01b3109a5517d68ca",
]
store_db_secret_policy_arn = "arn:aws:iam::088354478627:policy/south-jersey-eks-tchatua-dev-retailstore-db-secret-policy"
vpc_id = "vpc-06ee6ef7669455f52"
-------------------------------------------
All Terraform steps completed successfully!
-------------------------------------------
