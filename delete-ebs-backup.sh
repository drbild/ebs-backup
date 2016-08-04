#!/bin/sh

set -e

# Delete the various pieces
cd events; ./create-schedule-targets.sh; cd ..
cd lambda; ./create-lambda-functions.sh; cd ..
cd events; ./create-schedule-rule.sh;    cd ..
cd iam;    ./create-iam-role.sh;         cd ..
