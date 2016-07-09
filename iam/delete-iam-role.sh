#!/bin/sh

set -e

# Delete the service role policy
aws iam delete-role-policy --role-name ebs-backup-worker \
    --policy-name EbsBackupPolicy

# Delete the service role
aws iam delete-role --role-name ebs-backup-worker
