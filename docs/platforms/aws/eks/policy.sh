#!/bin/bash

set -euf -o pipefail

read -rp "Tell me the bucket_name: " bucket_name

cat << EOF > policy.json
{
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"s3:ListBucket"
			],
			"Resource": "arn:aws:s3:::${bucket_name}"
		},
		{
			"Effect": "Allow",
			"Action": [
				"s3:PutObject",
				"s3:GetObject",
				"s3:DeleteObject"
			],
			"Resource": "arn:aws:s3:::${bucket_name}/*"
		}
	],
	"Version": "2012-10-17"
}
EOF

echo "Policy created"
echo "You can also use the AWSBackupServiceRolePolicyForS3Backup predefined policy"