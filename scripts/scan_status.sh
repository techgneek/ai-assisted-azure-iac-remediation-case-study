#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${PROJECT_DIR}/.env"
SCAN_ID_FILE="${PROJECT_DIR}/.nessus-baseline-scan-id"

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "Missing ${ENV_FILE}"
  exit 1
fi

if [[ ! -f "${SCAN_ID_FILE}" ]]; then
  echo "Missing ${SCAN_ID_FILE}. Create or launch the baseline scan first."
  exit 1
fi

set -a
source "${ENV_FILE}"
set +a

SCAN_ID="$(cat "${SCAN_ID_FILE}")"

curl -k --fail --silent --show-error \
  "${TENABLE_URL}/scans/${SCAN_ID}" \
  -H "X-ApiKeys: accessKey=${TENABLE_ACCESS_KEY}; secretKey=${TENABLE_SECRET_KEY}" \
  | jq '{id: .info.object_id, name: .info.name, status: .info.status, targets: .info.targets}'
