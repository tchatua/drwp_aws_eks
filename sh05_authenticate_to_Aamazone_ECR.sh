#!/bin/bash

set -e  # Exit immediately if any command fails

echo "----------------------------------------------------------------"
echo "Authenticating to Amazon Public ECR (token valid for 12 hours)"
echo "----------------------------------------------------------------"

aws ecr-public get-login-password --region us-east-1 | \
helm registry login -u AWS --password-stdin public.ecr.aws
