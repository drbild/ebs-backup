#!/bin/sh

set -e

# Delete the targets
aws events remove-targets                                   \
    --rule ebs-worker-schedule                              \
    --targets "ebs-backup-snapshotter" "ebs-backup-janitor"
