# Phase 2 - OWASP Juice Shop Setup

## Purpose

OWASP Juice Shop was installed as an intentionally vulnerable web application on the Azure target VM. This gives the case study a controlled vulnerable workload for vulnerability scanning, triage, remediation planning, and before/after evidence.

## Architecture

- Scanner VM: `tflearn-nessus-scanner-vm`
- Target VM: `tflearn-ubuntu-vm`
- Target private IP: `10.10.1.4`
- Juice Shop URL from scanner VM: `http://10.10.1.4:3000`

## Install Method

Docker was installed on the target VM, then Juice Shop was run as a container.

```bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl enable --now docker
sudo docker pull bkimminich/juice-shop
sudo docker run -d --name juice-shop --restart unless-stopped -p 3000:3000 bkimminich/juice-shop
```

## Verification

The scanner VM successfully reached Juice Shop over the private Azure network.

```bash
curl -I http://10.10.1.4:3000
```

Observed response:

```text
HTTP/1.1 200 OK
```

## Security Posture

- Juice Shop is reachable from inside the Azure VNet.
- The target VM's public NSG rules were not opened for port `3000`.
- This keeps the vulnerable application out of direct internet exposure while still allowing internal vulnerability scanning.

## Next Step

Run a second Nmap scan and a second Nessus scan against `10.10.1.4:3000`, then compare the results against the clean baseline scan.
