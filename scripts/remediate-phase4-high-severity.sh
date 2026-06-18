#!/usr/bin/env bash
set -euo pipefail

# Phase 4 high-severity remediation script for the Azure Terraform security case study.
# Purpose:
#   Remove internal-only vulnerable case study services that generated Critical Nessus findings.
#
# This script is intended to run on the target VM: tflearn-ubuntu-vm.
#
# Remediated case study services:
#   - metasploitable2-lab container mapped to 8021,8022,8023,8083,8180,8667
#   - vulnerable-apache-249 container mapped to 8082

echo "=== Before remediation listening services ==="
sudo ss -tulpen | grep -E ':(8021|8022|8023|8082|8083|8180|8667)\b' || true
sudo docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Ports}}'

echo
echo "=== Removing high-severity vulnerable case study containers ==="
sudo docker stop metasploitable2-lab >/dev/null 2>&1 || true
sudo docker rm metasploitable2-lab >/dev/null 2>&1 || true

sudo docker stop vulnerable-apache-249 >/dev/null 2>&1 || true
sudo docker rm vulnerable-apache-249 >/dev/null 2>&1 || true

echo
echo "=== After remediation listening services ==="
sudo ss -tulpen | grep -E ':(8021|8022|8023|8082|8083|8180|8667)\b' || true
sudo docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Ports}}'

echo
echo "High-severity remediation complete."
