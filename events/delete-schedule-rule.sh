#!/bin/sh

set -e

# Delete the scheduled rule
aws events delete-rule --name ebs-backup-schedule
