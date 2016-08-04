#!/bin/sh

set -e

# Create various pieces in correct order
cd iam;    ./create-iam-role.sh;         cd ..
cd events; ./create-schedule-rule.sh;    cd ..
cd lambda; ./create-lambda-functions.sh; cd ..
cd events; ./create-schedule-targets.sh; cd ..
