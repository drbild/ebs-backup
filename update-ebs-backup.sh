#!/bin/sh

set -e

# Update various pieces in correct order
cd iam;    ./update-iam-role.sh;         cd ..
cd events; ./update-schedule-rule.sh;    cd ..
cd lambda; ./update-lambda-functions.sh; cd ..
cd events; ./update-schedule-targets.sh; cd ..
