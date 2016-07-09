#!/bin/sh

set -e

# Update the the role trust policy
aws iam update-assume-role-policy  --role-name ebs-backup-worker \
    --policy-document file://ebs-backup-trust.json

# Update the inline role policy
aws iam put-role-policy --role-name ebs-backup-worker \
    --policy-name EbsBackupPolicy                     \
    --policy-document file://ebs-backup-policy.json
