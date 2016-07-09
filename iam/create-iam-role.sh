#!/bin/sh

set -e

# Create the IAM service role for AWS Lambda
aws iam create-role --role-name ebs-backup-worker \
    --assume-role-policy-document file://ebs-backup-trust.json

# Allow the new role to managed snapshots
aws iam put-role-policy --role-name ebs-backup-worker \
    --policy-name EbsBackupPolicy                     \
    --policy-document file://ebs-backup-policy.json
