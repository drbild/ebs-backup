#!/bin/bash

set -e

# Zip the handler code into a distribution
DIST=$(mktemp -t ebs-backup-handlers-XXXXXX.zip)
trap 'rm -f ${DIST}' EXIT
rm ${DIST}; zip ${DIST} ebs-backup-snapshotter.py ebs-backup-janitor.py

# Get the ARN of the ebs-backup-worker IAM role
ROLE=$(aws iam get-role --role-name ebs-backup-worker | jq -r .Role.Arn)

# Update the function to take snapshots
aws lambda update-function-configuration                                        \
    --function-name ebs-backup-snapshotter                                      \
    --description "creates a snapshot of any EBS volume with a 'Backup' tag"    \
    --role ${ROLE}                                                              \
    --runtime python2.7                                                         \
    --handler ebs-backup-snapshotter.lambda_handler

aws lambda update-function-code                                                 \
    --function-name ebs-backup-snapshotter                                      \
    --zip-file fileb://${DIST}

# Update the function to remove old snapshots
aws lambda update-function-configuration                                        \
    --function-name ebs-backup-janitor                                          \
    --description "creates a snapshot of any EBS volume with a 'Backup' tag"    \
    --role ${ROLE}                                                              \
    --runtime python2.7                                                         \
    --handler ebs-backup-janitor.lambda_handler

aws lambda update-function-code                                                 \
    --function-name ebs-backup-janitor                                          \
    --zip-file fileb://${DIST}

# Get the ARN of the ebs-backup-schedule Events rule
RULE=$(aws events list-rules --name-prefix ebs-backup-schedule | jq -r .Rules[0].Arn)

# Give Events permission to run the new functions
aws lambda remove-permission --function-name ebs-backup-snapshotter     \
    --statement-id ebs-backup-snapshotter-statement

aws lambda remove-permission --function-name ebs-backup-janitor         \
    --statement-id ebs-backup-janitor-statement

aws lambda add-permission --function-name ebs-backup-snapshotter        \
    --statement-id ebs-backup-snapshotter-statement                     \
    --action lambda:InvokeFucntion					\
    --principal events.amazonaws.com					\
    --source-arn "${RULE}"

aws lambda add-permission --function-name ebs-backup-janitor            \
    --statement-id ebs-backup-janitor-statement                         \
    --action lambda:InvokeFucntion					\
    --principal events.amazonaws.com					\
    --source-arn "${RULE}"
