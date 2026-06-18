#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${PROJECT_DIR}/.env"

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "Missing ${ENV_FILE}"
  echo "Copy .env.example to .env, then add your Tenable API keys."
  exit 1
fi

set -a
source "${ENV_FILE}"
set +a

if [[ -z "${TENABLE_URL:-}" || -z "${TENABLE_ACCESS_KEY:-}" || -z "${TENABLE_SECRET_KEY:-}" ]]; then
  echo "TENABLE_URL, TENABLE_ACCESS_KEY, and TENABLE_SECRET_KEY must be set in .env"
  exit 1
fi

curl -k --fail --silent --show-error \
  "${TENABLE_URL}/server/status" \
  -H "X-ApiKeys: accessKey=${TENABLE_ACCESS_KEY}; secretKey=${TENABLE_SECRET_KEY}"

echo
