#!/bin/bash

set -e

# Delete the permissions
aws lambda remove-permission --function-name ebs-backup-snapshotter \
    --statement-id ebs-backup-snapshotter-statement

aws lambda remove-permission --function-name ebs-backup-janitor     \
    --statement-id ebs-backup-janitor-statement

# Delete the functions
aws lambda delete-function --function-name ebs-backup-snapshotter
aws lambda delete-function --function-name ebs-backup-janitor
