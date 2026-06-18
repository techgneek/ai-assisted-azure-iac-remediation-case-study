#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${PROJECT_DIR}/.env"
SCAN_ID_FILE="${PROJECT_DIR}/.nessus-baseline-scan-id"

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "Missing ${ENV_FILE}"
  echo "Copy .env.example to .env, then add your Nessus values."
  exit 1
fi

set -a
source "${ENV_FILE}"
set +a

if [[ -z "${TENABLE_URL:-}" || -z "${NESSUS_USERNAME:-}" || -z "${NESSUS_PASSWORD:-}" ]]; then
  echo "TENABLE_URL, NESSUS_USERNAME, and NESSUS_PASSWORD must be set in .env"
  exit 1
fi

TARGET="${1:-10.10.1.4}"
SCAN_NAME="${2:-Azure Ubuntu Target - Baseline Internal Scan}"
BASIC_TEMPLATE_UUID="731a8e52-3ea6-a291-ec0a-d2ff0619c19d7bd788d6be818b65"

TOKEN="$(
  curl -k --fail --silent --show-error \
    "${TENABLE_URL}/session" \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"${NESSUS_USERNAME}\",\"password\":\"${NESSUS_PASSWORD}\"}" \
    | jq -r '.token'
)"

if [[ -z "${TOKEN}" || "${TOKEN}" == "null" ]]; then
  echo "Could not get Nessus session token."
  exit 1
fi

NESSUS_JS="$(mktemp)"
trap 'rm -f "${NESSUS_JS}"' EXIT

curl -k --fail --silent --show-error \
  "${TENABLE_URL}/nessus6.js" \
  -o "${NESSUS_JS}"

API_TOKEN="$(
  perl -ne 'if (/key:"getApiToken",value:function\(\)\{return"([^"]+)"/) { print $1; exit }' "${NESSUS_JS}"
)"

if [[ -z "${API_TOKEN}" ]]; then
  echo "Could not get Nessus UI API token."
  exit 1
fi

SCAN_ID="$(
  curl -k --fail --silent --show-error \
    "${TENABLE_URL}/scans" \
    -H "X-Cookie: token=${TOKEN}" \
    -H "X-Api-Token: ${API_TOKEN}" \
    -H "Content-Type: application/json" \
    -d @- <<JSON | jq -r '.scan.id'
{
  "uuid": "${BASIC_TEMPLATE_UUID}",
  "settings": {
    "name": "${SCAN_NAME}",
    "description": "First baseline scan of the Azure Ubuntu target VM from the dedicated Nessus scanner VM.",
    "folder_id": 3,
    "scanner_id": 1,
    "text_targets": "${TARGET}",
    "enabled": false,
    "launch": "ON_DEMAND"
  }
}
JSON
)"

if [[ -z "${SCAN_ID}" || "${SCAN_ID}" == "null" ]]; then
  echo "Could not create Nessus scan."
  exit 1
fi

echo "${SCAN_ID}" > "${SCAN_ID_FILE}"

curl -k --fail --silent --show-error \
  -X POST "${TENABLE_URL}/scans/${SCAN_ID}/launch" \
  -H "X-Cookie: token=${TOKEN}" \
  -H "X-Api-Token: ${API_TOKEN}" \
  -H "Content-Type: application/json" \
  | jq '{scan_uuid: .scan_uuid}'

echo "Created and launched scan id: ${SCAN_ID}"
echo "Saved scan id to ${SCAN_ID_FILE}"
