#!/bin/sh

set -e

# Get the ARN of the ebs-backup-{snapshotter,janitor} Lambda function
FUNC1=$(aws lambda get-function --function-name ebs-backup-snapshotter | jq -r .Configuration.FunctionArn)
FUNC2=$(aws lambda get-function --function-name ebs-backup-janitor | jq -r .Configuration.FunctionArn)

# Create targets to run the ebs-backup-{snapshotter,janitor} Lambda functions
aws events put-targets                                  \
    --rule ebs-worker-schedule                          \
    --targets "Id=ebs-backup-snapshotter,Arn=${FUNC1}"

aws events put-targets		                        \
    --rule ebs-worker-schedule	                        \
    --targets "Id=ebs-backup-janitor,Arn=${FUNC2}"
