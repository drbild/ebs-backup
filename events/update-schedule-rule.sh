#!/bin/sh

set -e

# Update the schedule rule
aws events put-rule --name ebs-backup-schedule \
    --schedule-expression 'rate(1 day)'
