# Phase 4 Remediation Validation Summary

## Remediation Performed

Two vulnerable-mode findings were remediated manually:

1. Anonymous FTP on `2121/tcp`
2. Directory-listing web service on `8081/tcp`

## Technical Actions

Remediation script:

- `scripts/remediate-phase4-vulnerabilities.sh`

Anonymous FTP:

- Stopped `vsftpd`
- Disabled `vsftpd` from starting on boot
- Changed `anonymous_enable` to `NO` in `/etc/vsftpd.conf`

Directory-listing web service:

- Stopped the `vulnerable-dir-listing` Docker container
- Removed the `vulnerable-dir-listing` Docker container
- Left a local remediation note at `/opt/vulnerable-web/REMEDIATED.txt`

## Before Remediation

Nmap confirmed these services were open:

| Port | State | Finding |
| --- | --- | --- |
| `2121/tcp` | Open | Anonymous FTP login allowed |
| `8081/tcp` | Open | Nginx directory listing enabled |

## After Remediation

Post-remediation Nmap scan confirmed:

| Port | State | Result |
| --- | --- | --- |
| `2121/tcp` | Closed | Anonymous FTP no longer reachable |
| `8081/tcp` | Closed | Directory-listing web service no longer reachable |

The following case study services intentionally remain available:

| Port | Service | Reason |
| --- | --- | --- |
| `3000/tcp` | OWASP Juice Shop | Retained for web app testing practice |
| `8080/tcp` | DVWA | Retained for web app testing practice |

## Validation Evidence

Post-remediation Nmap artifacts:

- `reports/phase-4-remediation/nmap/azure-target-post-remediation.nmap`
- `reports/phase-4-remediation/nmap/azure-target-post-remediation.gnmap`
- `reports/phase-4-remediation/nmap/azure-target-post-remediation.xml`

Enterprise process documentation:

- `reports/phase-4-remediation/enterprise-remediation-process.md`

## Outcome

The selected vulnerabilities were successfully remediated.

The before-and-after evidence supports an enterprise-style remediation story:

1. Vulnerability discovered.
2. Asset owner notified.
3. Risk prioritized.
4. Change request approved.
5. Remediation implemented.
6. Validation scan completed.
7. Findings confirmed closed.
