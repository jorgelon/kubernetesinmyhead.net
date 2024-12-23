#!/bin/bash

set -euf -o pipefail

# Prompt for namespace and service account
read -rp "Enter the namespace: " NAMESPACE
read -rp "Enter the service account: " SERVICE_ACCOUNT

# Get the AWS account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

# Get the EKS cluster name
CLUSTER_NAME=$(aws eks list-clusters --query "clusters[0]" --output text)

# Get the OIDC provider URL
OIDC_PROVIDER_URL=$(aws eks describe-cluster --name "${CLUSTER_NAME}" --query "cluster.identity.oidc.issuer" --output text)

# Extract the OIDC provider ID from the URL
OIDC_PROVIDER_ID=$(echo "${OIDC_PROVIDER_URL}" | sed 's|https://||')

# Generate the trust relationship policy
TRUST_RELATIONSHIP=$(
    cat <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::$ACCOUNT_ID:oidc-provider/$OIDC_PROVIDER_ID"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "$OIDC_PROVIDER_ID:aud": "sts.amazonaws.com",
                    "$OIDC_PROVIDER_ID:sub": "system:serviceaccount:$NAMESPACE:$SERVICE_ACCOUNT"
                }
            }
        }
    ]
}
EOF
)

# Output the trust relationship policy
echo "$TRUST_RELATIONSHIP"
