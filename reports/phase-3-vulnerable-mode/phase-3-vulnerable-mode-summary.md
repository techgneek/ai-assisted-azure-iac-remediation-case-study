# Phase 3 Summary: Vulnerable Mode

## Purpose

Phase 3 intentionally added vulnerable services to the Azure Ubuntu target VM so the case study can produce meaningful scanner telemetry before a later remediation and rescan.

## Target

- VM: `tflearn-ubuntu-vm`
- Private IP: `10.10.1.4`
- Public IP: `REDACTED`
- Scanner VM: `tflearn-nessus-scanner-vm`

## Vulnerable Mode Services

| Port | Service | Purpose |
| --- | --- | --- |
| `2121/tcp` | Anonymous FTP | Demonstrate anonymous access and exposed files |
| `3000/tcp` | OWASP Juice Shop | Intentionally vulnerable web app |
| `8080/tcp` | DVWA | Intentionally vulnerable web app |
| `8081/tcp` | Nginx directory listing | Demonstrate exposed backup/config files |

Local software inventory item:

- Firefox `115.0` installed at `/opt/vulnerable-firefox`

## Exposure Control

No public inbound NSG rules were added for the vulnerable service ports.

The target NSG currently allows only SSH from James's home IP. Scanner access to vulnerable services works over the Azure virtual network path between the scanner VM and the target VM.

## Nmap Results

Nmap confirmed:

- Anonymous FTP login allowed on `2121/tcp`
- Juice Shop reachable on `3000/tcp`
- DVWA reachable on `8080/tcp`
- Directory listing enabled on `8081/tcp`
- Exposed backup-style files under `/backups/`

Nmap artifacts:

- `reports/phase-3-vulnerable-mode/nmap/azure-target-vulnerable-mode.nmap`
- `reports/phase-3-vulnerable-mode/nmap/azure-target-vulnerable-mode.gnmap`
- `reports/phase-3-vulnerable-mode/nmap/azure-target-vulnerable-mode.xml`
- `reports/phase-3-vulnerable-mode/nmap/azure-target-vulnerable-mode-nmap-summary.md`

Nmap screenshot evidence:

- `reports/phase-3-vulnerable-mode/screenshots/nmap-vulnerable-mode-raw-results.png`
- `reports/phase-3-vulnerable-mode/screenshots/nmap-vulnerable-mode-key-findings.png`
- `reports/phase-3-vulnerable-mode/screenshots/nmap-vulnerable-mode-summary.png`

## Nessus Results

Nessus scan:

- Scan name: `Azure Target - Vulnerable Mode Scan`
- Target: `10.10.1.4`
- Status: Completed
- Hosts scanned: 1

Severity counts:

- Critical: 0
- High: 0
- Medium: 1
- Low: 1
- Info: 30

Notable findings:

- Medium: `nginx 1.3.0 < 1.28.2 / 1.29.x < 1.29.5 SSL Upstream Injection`
- Low: `ICMP Timestamp Request Remote Date Disclosure`
- Info: FTP server detection
- Info: Apache HTTP Server version
- Info: nginx HTTP server detection
- Info: Web Server `robots.txt` information disclosure
- Info: SSH SHA-1 HMAC algorithms enabled

Nessus artifacts:

- `reports/phase-3-vulnerable-mode/nessus-vulnerable-mode-scan.json`
- `reports/phase-3-vulnerable-mode/nessus-vulnerable-mode-summary.json`
- `reports/phase-3-vulnerable-mode/nessus-vulnerable-mode-summary.md`

## Remediation Plan

Later remediation can include:

- Stop/remove the DVWA container.
- Stop/remove the vulnerable directory-listing Nginx container.
- Disable anonymous FTP and stop `vsftpd`.
- Remove fake exposed backup files.
- Remove the old Firefox install.
- Rescan with Nmap and Nessus.
- Compare before and after findings.
