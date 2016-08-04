#!/bin/sh

set -e

# Create a rule that self- triggers daily
aws events put-rule --name ebs-backup-schedule \
    --schedule-expression 'rate(1 day)'
