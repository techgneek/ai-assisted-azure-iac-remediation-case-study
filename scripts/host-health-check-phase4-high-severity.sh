#!/usr/bin/env bash
set -euo pipefail

# Phase 4 high-severity host health check.
# Purpose:
#   Provide host-side validation that the remediated high-severity case study services
#   are no longer running or listening on the target VM.
#
# This script is intended to run on the target VM: tflearn-ubuntu-vm.

PORT_PATTERN=':(8021|8022|8023|8082|8083|8180|8667)\b'
CONTAINER_PATTERN='metasploitable2-lab|vulnerable-apache-249'

echo "=== Phase 4 High-Severity Host Health Check ==="
echo "Timestamp: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
echo "Hostname: $(hostname)"
echo

echo "=== Running containers ==="
sudo docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Ports}}'
echo

echo "=== Checking for remediated containers ==="
if sudo docker ps -a --format '{{.Names}}' | grep -E "$CONTAINER_PATTERN"; then
  echo "FAIL: One or more remediated vulnerable containers still exist."
  exit 1
else
  echo "PASS: Remediated vulnerable containers are not present."
fi
echo

echo "=== Checking remediated listening ports ==="
if sudo ss -tulpen | grep -E "$PORT_PATTERN"; then
  echo "FAIL: One or more remediated high-severity ports are still listening."
  exit 1
else
  echo "PASS: Remediated high-severity ports are not listening."
fi
echo

echo "=== Services intentionally retained for later case study practice ==="
sudo ss -tulpen | grep -E ':(3000|8080)\b' || true
echo

echo "HEALTH CHECK RESULT: PASS"
