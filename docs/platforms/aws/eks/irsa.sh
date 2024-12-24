#!/bin/bash

set -euf -o pipefail

echo "We need account_id, oidc_provider, namespace, and service_account"

echo "Listing clusters"
aws eks list-clusters  --output text
read -rp "Tell me the cluster: " cluster_name

echo "Getting account_id"
account_id=$(aws sts get-caller-identity --query "Account" --output text)

echo "Getting oidc_provider"
oidc_provider=$(aws eks describe-cluster --name "${cluster_name}" --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")

read -rp "Enter the namespace: " namespace
read -rp "Enter the service account: " service_account

echo "We have account_id: $account_id, oidc_provider: $oidc_provider, namespace: $namespace, service_account: $service_account"

echo "Creating trust relationship"
cat << EOF > trust-relationship.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::$account_id:oidc-provider/$oidc_provider"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "$oidc_provider:aud": "sts.amazonaws.com",
          "$oidc_provider:sub": "system:serviceaccount:$namespace:$service_account"
        }
      }
    }
  ]
}
EOF
