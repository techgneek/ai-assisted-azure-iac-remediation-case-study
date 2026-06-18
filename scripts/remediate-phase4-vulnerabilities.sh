#!/usr/bin/env bash
set -euo pipefail

# Phase 4 remediation script for the Azure Terraform security case study.
# Purpose:
#   1. Disable anonymous FTP on port 2121.
#   2. Remove the vulnerable Nginx directory-listing container on port 8081.
#
# This script is intended to run on the target VM: tflearn-ubuntu-vm.

echo "=== Before remediation listening services ==="
sudo ss -tulpen | grep -E ':(2121|3000|8080|8081)\b' || true
sudo docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Ports}}'

echo
echo "=== Remediating anonymous FTP ==="
sudo systemctl stop vsftpd || true
sudo systemctl disable vsftpd || true

if [ -f /etc/vsftpd.conf ]; then
  sudo cp /etc/vsftpd.conf "/etc/vsftpd.conf.pre-remediation.$(date +%Y%m%d%H%M%S)"
  sudo sed -i 's/^anonymous_enable=.*/anonymous_enable=NO/' /etc/vsftpd.conf || true
fi

echo
echo "=== Remediating directory-listing web service ==="
sudo docker stop vulnerable-dir-listing >/dev/null 2>&1 || true
sudo docker rm vulnerable-dir-listing >/dev/null 2>&1 || true

sudo tee /opt/vulnerable-web/REMEDIATED.txt >/dev/null <<'EOF'
Directory listing container was removed during Phase 4 remediation.
Exposed backup-style files are no longer being served on port 8081.
EOF

echo
echo "=== After remediation listening services ==="
sudo ss -tulpen | grep -E ':(2121|3000|8080|8081)\b' || true
sudo docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Ports}}'

echo
echo "Remediation complete."
