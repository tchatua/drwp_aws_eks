# 

## Create IAM Policy

This policy grants permission to read one secret — catalog-db-secret — from AWS Secrets Manager.

VERY VERY IMPORTANT NOTE: We’re scoping access to only one secret (catalog-db-secret*) — least-privilege best practice.


```json
# Change Directory
cd iam-policy-json-files

# Create Catalog DB Secret Policy JSON file
cat <<EOF > catalog-db-secret-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ],
      "Resource": "arn:aws:secretsmanager:us-east-2:088354478627:secret:catalog-db-secret*"
    }
  ]
}
EOF
```

## Create the policy:


```sh
# Change Directory
cd f01_IAM_Policy_JSON_Files

# Create IAM Policy
aws iam create-policy \
  --policy-name catalog-db-secret-policy \
  --policy-document file://a09_catalog_db_secret_policy.json
```

```sh
aws iam create-policy --policy-name catalog-db-secret-policy --policy-document file://a09_catalog_db_secret_policy.json
{
    "Policy": {
        "PolicyName": "catalog-db-secret-policy",
        "PolicyId": "ANPARJESWLIRRCOMYT2MH",
        "Arn": "arn:aws:iam::088354478627:policy/catalog-db-secret-policy",
        "Path": "/",
        "DefaultVersionId": "v1",
        "AttachmentCount": 0,
        "PermissionsBoundaryUsageCount": 0,
        "IsAttachable": true,
        "CreateDate": "2026-06-11T23:12:52+00:00",
        "UpdateDate": "2026-06-11T23:12:52+00:00"
    }
}
```

## Create IAM Role for Pod Identity

Create the trust policy that allows EKS Pods to assume this role through the Pod Identity Agent.

```sh
# Create IAM Role
aws iam create-role \
  --role-name catalog-db-secrets-role \
  --assume-role-policy-document file://a10_iam_policy_json_files.json
# -----------------------------------------------------------------------------------------------------
```

## Create IAM Role for Pod Identity

Create the trust policy that allows EKS Pods to assume this role through the Pod Identity Agent.

```sh
aws iam create-role --role-name catalog-db-secrets-role --assume-role-policy-document file://a10_trust_policy.json
{
    "Role": {
        "Path": "/",
        "RoleName": "catalog-db-secrets-role",
        "RoleId": "AROARJESWLIR7BDRY6CDJ",
        "Arn": "arn:aws:iam::088354478627:role/catalog-db-secrets-role",
        "CreateDate": "2026-06-12T00:04:44+00:00",
        "AssumeRolePolicyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "pods.eks.amazonaws.com"
                    },
                    "Action": [
                        "sts:AssumeRole",
                        "sts:TagSession"
                    ]
                }
            ]
        }
    }
}
```

## Attach the policy to the role:

```sh
# Attach the IAM policy to IAM Role
aws iam attach-role-policy \
  --role-name catalog-db-secrets-role \
  --policy-arn arn:aws:iam::${AWS_ACCOUNT_ID}:policy/catalog-db-secret-policy
```

```sh
# Attach the IAM policy to IAM Role
aws iam attach-role-policy --role-name catalog-db-secrets-role --policy-arn arn:aws:iam::${AWS_ACCOUNT_ID}:policy/catalog-db-secret-policy

```

## Verify attachment:

```sh
# List Attached Policies to IAM Role
aws iam list-attached-role-policies --role-name catalog-db-secrets-role
# -----------------------------------------------------------------------------------------------------

aws iam list-attached-role-policies --role-name catalog-db-secrets-role
{
    "AttachedPolicies": [
        {
            "PolicyName": "catalog-db-secret-policy",
            "PolicyArn": "arn:aws:iam::088354478627:policy/catalog-db-secret-policy"
        }
    ]
}
```

##  Create Pod Identity Association

Now I’ll associate this IAM role with the Kubernetes ServiceAccount catalog-mysql-sa 
so the MySQL StatefulSet can access the secret.

It’s not an issue if the ServiceAccount doesn’t exist yet — 
it will be created later with the same name when deploying the StatefulSet.


```sh
# # Verify Amazon EKS Pod Identity Agent Installation
# aws eks list-addons --cluster-name ${EKS_CLUSTER_NAME}
# # -----------------------------------------------------------------------------------------------------
# ## Sample Output
# {
#     "addons": [
#         "eks-pod-identity-agent"
#     ]
# }
# # -----------------------------------------------------------------------------------------------------

aws eks list-clusters
{
    "clusters": [
        "south-jersey-eks-tchatua-dev-eks-control-plane"
    ]
}

EKS_CLUSTER_NAME="south-jersey-eks-tchatua-dev-eks-control-plane"
# # -----------------------------------------------------------------------------------------------------

# Create Pod Identity Association
aws eks create-pod-identity-association \
  --cluster-name ${EKS_CLUSTER_NAME} \
  --namespace default \
  --service-account catalog-mysql-sa \
  --role-arn arn:aws:iam::${AWS_ACCOUNT_ID}:role/catalog-db-secrets-role
# -----------------------------------------------------------------------------------------------------

aws eks create-pod-identity-association   --cluster-name ${EKS_CLUSTER_NAME}   --namespace default   --service-account catalog-mysql-sa   --role-arn arn:aws:iam::${AWS_ACCOUNT_ID}:role/catalog-db-secrets-role
{
    "association": {
        "clusterName": "south-jersey-eks-tchatua-dev-eks-control-plane",
        "namespace": "default",
        "serviceAccount": "catalog-mysql-sa",
        "roleArn": "arn:aws:iam::088354478627:role/catalog-db-secrets-role",
        "associationArn": "arn:aws:eks:us-east-2:088354478627:podidentityassociation/south-jersey-eks-tchatua-dev-eks-control-plane/a-dqtf1nyltqlhkph5h",
        "associationId": "a-dqtf1nyltqlhkph5h",
        "tags": {},
        "createdAt": "2026-06-11T20:42:50.861000-04:00",
        "modifiedAt": "2026-06-11T20:42:50.861000-04:00",
        "disableSessionTags": false
    }
}
```

## Verify Pod Identity Association

List all associations in your cluster:

```sh
# List Pod Identity Associations
aws eks list-pod-identity-associations --cluster-name ${EKS_CLUSTER_NAME}

# -----------------------------------------------------------------------------------------------------
aws eks list-pod-identity-associations --cluster-name ${EKS_CLUSTER_NAME}
{
    "associations": [
        {
            "clusterName": "south-jersey-eks-tchatua-dev-eks-control-plane",
            "namespace": "default",
            "serviceAccount": "catalog-mysql-sa",
            "associationArn": "arn:aws:eks:us-east-2:088354478627:podidentityassociation/south-jersey-eks-tchatua-dev-eks-control-plane/a-dqtf1nyltqlhkph5h",
            "associationId": "a-dqtf1nyltqlhkph5h"
        }
    ]
}
```



