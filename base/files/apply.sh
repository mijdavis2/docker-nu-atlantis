#!/bin/bash
#
# Perform terragrunt 'apply' with secure and terse output.

set -o pipefail
terragrunt apply "${PLANFILE}" | tfmask

# Terragrunt has detailed exit codes
# so we check status_code explicitly
# and exit to ensure proper atlantis build status.
STATUS_CODE=$?
if [[ $STATUS_CODE -ne 1 ]]; then
  exit 0
else
  exit 1
fi
