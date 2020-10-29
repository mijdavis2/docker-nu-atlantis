#!/bin/bash
#
# Perform terragrunt plan with secure and terse output.

# Terragrunt has notoriously noisy output
# and it all goes to stderr...
#
# Store stdout and stderr for future triage if necessary
# without printing to the console now.
PLAN_OUTPUT=$(terragrunt plan -out="${PLANFILE}" 2>&1 >/dev/null)

# On success, show plan output without terragrunt noise
# and pipe through tfmask for security.
#
# On failure, show full plan command output
# again piping thru tfmask for security.
STATUS_CODE=$?
if [[ $STATUS_CODE -eq 0 ]]; then
    terragrunt show "${PLANFILE}" 2>/dev/null | tfmask | grep -v "credstash -"
else
    echo "${PLAN_OUTPUT}" | tfmask | grep -v "credstash -"
    exit "${STATUS_CODE}"
fi
