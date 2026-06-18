# Phase 4: Enterprise Remediation Process

## Scenario

This case study simulates an enterprise vulnerability management workflow for a production-facing server used by a fictional Security Assessment Platform Team.

For the purpose of the portfolio story, the affected system is treated as public-facing and production-sensitive, even though the Azure case study environment was kept internally reachable from the scanner VM only.

## Roles

In a real enterprise environment, these duties are usually separated:

- Vulnerability Management Team: Runs scans, validates findings, assigns severity, and opens remediation tickets.
- Application or Server Owner: Owns the affected asset and confirms business impact.
- Change Advisory Board: Reviews production change risk and approves or rejects implementation.
- Remediation Team: Performs the approved technical fix.
- Security Team: Performs validation scanning after remediation.

In this case study, James and Codex are acting as both the detection team and the remediation team so the full lifecycle can be demonstrated end to end.

## Discovery

The vulnerable-mode scan identified multiple issues on the target server:

- Anonymous FTP exposed on `2121/tcp`
- Directory listing and exposed backup files on `8081/tcp`
- DVWA exposed on `8080/tcp`
- OWASP Juice Shop exposed on `3000/tcp`
- Nessus Medium finding related to the Nginx service
- Nessus Low finding for ICMP timestamp disclosure

## Business Discussion

The vulnerability management team notifies the server/application owner:

> A scan identified publicly reachable services on the internal security assessment platform. Anonymous FTP and an exposed backup directory are present. These services may disclose sensitive data or provide reconnaissance value to an attacker.

The server owner confirms:

- The server is production-sensitive.
- The exposed FTP service is not required.
- The directory-listing web service is not required.
- Remediation can proceed under an emergency or expedited change window.

## Risk Prioritization

Because this scenario treats the asset as public-facing and production-sensitive, the remediation priority is elevated.

Priority factors:

- Public-facing exposure
- Sensitive business function
- Exposed files and directory listing
- Unnecessary services
- Low complexity remediation
- Low expected business impact from disabling the services

## Change Request

Change title:

> Disable anonymous FTP and remove exposed directory-listing web service from production internal security assessment platform.

Change reason:

> Vulnerability scan identified anonymous FTP and exposed backup files. These services are unnecessary and increase the system's external attack surface.

Implementation plan:

1. Disable and stop `vsftpd`.
2. Prevent `vsftpd` from starting on boot.
3. Stop and remove the vulnerable directory-listing Nginx container.
4. Verify ports `2121` and `8081` are no longer listening.
5. Rescan with Nmap.
6. Rescan with Nessus if needed.

Implementation script:

- `scripts/remediate-phase4-vulnerabilities.sh`

Rollback plan:

1. Re-enable and restart `vsftpd` if business impact is reported.
2. Recreate the Nginx directory-listing container only if explicitly approved.
3. Validate application availability after rollback.

Validation plan:

1. Confirm `2121/tcp` is closed.
2. Confirm `8081/tcp` is closed.
3. Confirm required services remain available.
4. Save before-and-after scan evidence.

CAB decision:

> Approved for expedited remediation due to public-facing exposure and low implementation risk.

## Remediation Scope

This phase remediates two findings:

- Anonymous FTP on `2121/tcp`
- Directory listing / exposed backup files on `8081/tcp`

DVWA and Juice Shop remain available for later web application testing practice.
